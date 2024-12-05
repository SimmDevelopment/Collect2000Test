SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GetCustomDataEmails] 
	-- Add the parameters for the stored procedure here
	@number int,
  @userid   int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @Columns TABLE (TableName varchar(50), number INT, sentdate VARCHAR(10))
IF EXISTS ( SELECT  *
                    FROM    tempdb.sys.tables
                    WHERE   name LIKE '#results%' ) 
            BEGIN
                DROP TABLE #results
            END
CREATE table #results (DateSent VARCHAR(10), Option1pay MONEY, Option2pay MONEY, Option3pay MONEY, duedate1 DATETIME, duedate2 DATETIME, duedate3 DATETIME, sif1 INT, sif2 INT, sif3 INT)

INSERT INTO @columns 
SELECT tr.tablename, lr.AccountID, CONVERT(VARCHAR(10), tr.date, 101)
FROM dbo.LetterRequest lr WITH (NOLOCK) INNER JOIN dbo.Custom_Email_Table_Reference tr WITH (NOLOCK) 
ON dbo.date(DateProcessed) = tr.date
WHERE LetterCode = 'email'
AND AccountID = @number

--select tablename, number, sentdate FROM @columns 

DECLARE @execquery AS NVARCHAR(MAX)
DECLARE @tablename AS NVARCHAR(128)
DECLARE @sentdate1 AS VARCHAR(10)


declare cur cursor for 

	select tablename, number, sentdate FROM @columns 

open cur

fetch from cur into @tablename, @number, @sentdate1
while @@fetch_status = 0 BEGIN




SET @execquery = N'SELECT ''' + CONVERT(VARCHAR(10), @sentdate1) + ''', Current30, Current60, Current90, userdate1, userdate2, userdate3, PlanCode, PromoIndicator, ProviderType
FROM ' + QUOTENAME(@tablename) + ' WHERE number = ' + CONVERT(VARCHAR(15), @number)

INSERT INTO #results( DateSent , Option1pay , Option2pay , Option3pay , duedate1 , duedate2 ,
          duedate3 , sif1 , sif2 , sif3)
EXECUTE sp_executesql @execquery

fetch from cur into @tablename, @number, @sentdate1

END

SELECT  DateSent AS [Email Sent],  
CONVERT(VARCHAR(2), sif1) + '% at $' + CONVERT(VARCHAR(10), Option1pay) + ' Due ' + CONVERT(VARCHAR(10), duedate1, 101) AS [SIF Offer 1],
CONVERT(VARCHAR(2), sif2) + '% at $' + CONVERT(VARCHAR(10), Option2pay) + ' Due ' + CONVERT(VARCHAR(10), duedate2, 101) AS [SIF Offer 2], 
CONVERT(VARCHAR(2), sif3) + '% at $' + CONVERT(VARCHAR(10), Option3pay) + ' Due in 2 Installments ' + CONVERT(VARCHAR(10), duedate2, 101) + ' And ' + CONVERT(VARCHAR(10), duedate3, 101) AS [SIF Offer 3]
FROM #results
ORDER BY DateSent
DROP TABLE #results
--close and free up all the resources.
close cur
deallocate cur

END
GO
