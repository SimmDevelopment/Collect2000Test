SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spScheduleBrokenPromiseLetters] @DaysBroken tinyint = 7
AS

BEGIN TRY
	if exists (select * from dbo.sysobjects where id = object_id(N'bp_temp') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table bp_temp
END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

BEGIN TRY
	if not exists (select * from dbo.sysobjects where id = object_id(N'bp_letters') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	CREATE TABLE [bp_letters] (
		[id] [int] NOT NULL 
	) ON [PRIMARY]
END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

BEGIN TRY
	SELECT m.NUMBER,
	       promises1.id,
	       promises2.amount,
	       promises2.duedate
	INTO   BP_Temp
	FROM   master m
	       JOIN controlfile c
	         ON c.company <> ''
	       JOIN 
	          (SELECT MAX(p5.id) as id ,p5.AcctID as acctid
	                     FROM   promises p5
	                     WHERE 
	                            p5.duedate < REPLACE(CONVERT(VARCHAR(10),getdate(),102),'.','')
	                            AND p5.duedate >= REPLACE(CONVERT(VARCHAR(10),dateadd(day,-@DaysBroken,getdate()),102),'.','')
	                            AND p5.id NOT IN (SELECT ID
	                                              FROM   bp_letters)
	            AND p5.active = 0
				AND p5.Kept = 0
	            AND (p5.suspended is null or p5.Suspended <> 1)
	            GROUP BY p5.Acctid) promises1 on m.number = promises1.acctid
	       JOIN Promises as Promises2 on promises1.id = promises2.id

	WHERE  m.qlevel = '010'
	       AND (SELECT COUNT(*)
	            FROM   letterrequest l
	            WHERE  l.accountid = m.NUMBER
	                   AND l.lettercode = RTRIM(LTRIM(LEFT(letterbp,CHARINDEX('-',letterbp,1)-1)))
	                   AND l.daterequested >= (getdate() - @DaysBroken)
	                   AND l.deleted = 0) = 0
	       AND (SELECT COUNT(*)
	            FROM   promises p
	            WHERE  p.acctid = m.NUMBER
	                   AND duedate < REPLACE(CONVERT(VARCHAR(10),getdate(),102),'.','')
	                   AND duedate >= REPLACE(CONVERT(VARCHAR(10),dateadd(day,-@DaysBroken,getdate()),102),'.','')
	                   AND id NOT IN (SELECT ID
	                                  FROM   bp_letters)) > 0
END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

-- this block of code updates the BP_Letters table with a list
-- of promises that were examined up through today.
-- This runs after the BP request process.

BEGIN TRY

	BEGIN TRANSACTION

	INSERT INTO bp_letters(id)
	SELECT id
	FROM   promises
	WHERE  duedate < REPLACE(CONVERT(VARCHAR(10),getdate(),102),'.','')
           AND duedate >= REPLACE(CONVERT(VARCHAR(10),dateadd(day,-@DaysBroken,getdate()),102),'.','')
	       AND id NOT IN (SELECT id
	                      FROM   bp_letters)

	INSERT INTO notes(NUMBER,created,user0,ACTION,result,COMMENT)
	SELECT m.NUMBER,
	       getdate(),
	       'EVAL',
	       'SYS',
	       'BPROM',
	       'Broken Promise Letter Requested'
	FROM   master m
	WHERE  m.NUMBER IN (SELECT NUMBER
	                    FROM   BP_Temp)

	INSERT INTO future(NUMBER,Entered,Requested,ACTION,lettercode,letterdesc,duedate,amtdue)
	SELECT m.NUMBER,
	       getdate(),
	       getdate(),
	       'Letter',
		   RTRIM(LTRIM(LEFT(letterbp,CHARINDEX('-',letterbp,1)-1))),
		   RTRIM(LTRIM(RIGHT(letterbp,LEN(letterbp)-CHARINDEX('-',letterbp,1)))), 
	       l.duedate,
	       l.amount
	FROM   master m
	       JOIN controlfile c
	         ON c.company <> ''
	       JOIN bp_temp l
	         ON l.NUMBER = m.NUMBER
	WHERE  m.NUMBER IN (SELECT NUMBER
	                    FROM   BP_Temp)

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH

RETURN 0

GO
