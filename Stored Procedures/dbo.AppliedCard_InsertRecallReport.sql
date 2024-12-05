SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[AppliedCard_InsertRecallReport]
@number int,
@rundate datetime,
@filename varchar(500)
AS   
	INSERT INTO FirstData_RecallReport
	(RunDate,
	Account,
	currentprincipal,
	principalformatted,
	filename,
	number)
	SELECT 
	@rundate,
	m.account,
	m.current1,
	REPLACE(CAST(m.current1 as varchar(20)),'.',''),
	@filename,
	m.number
	FROM master m WITH (NOLOCK)
	WHERE m.number = @number

GO
