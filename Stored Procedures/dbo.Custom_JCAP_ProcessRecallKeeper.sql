SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_JCAP_ProcessRecallKeeper]
@number int

AS

DECLARE @status varchar(5)
DECLARE @qLevel varchar(3)
DECLARE @currDate datetime

SET @currDate = dbo.Date(GETDATE())

SELECT @status = status, @qlevel = qlevel
FROM master
WHERE number = @number

IF @status IN ('PDC', 'PPA', 'PCC', 'HOT', 'STL', 'REF', 'NSF') OR
	@qlevel IN ('010', '012', '018', '019', '025', '820', '830', '840')
BEGIN
	--keep account
	INSERT notes (number, created, user0, action, result, comment)
	VALUES (@number, @currDate, 'EXG', '+++++', '+++++', 
		'Account will not be closed because it meets keeper criteria.')

	INSERT Custom_JCAPKeeper
	VALUES (@number, @currDate)
END
ELSE
BEGIN
	EXEC sp_StatusChange2 @number, 'CCR', NULL
	EXEC StatusHistory_Insert @number, 'EXG', @status, 'CCR'
END



GO
