SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Post_Acct_CO_Values_Load] 
	-- Add the parameters for the stored procedure here
	@number int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE EarlyStageData
SET StatementDue = ISNULL((SELECT SUM(CAST(TheData AS MONEY))
FROM MiscExtra me WITH (NOLOCK)
WHERE Number = @number AND SUBSTRING(title, 1, 2) IN ('1A', '1B', '10', '11', '16', '18', '19', '30', '31', '32', '33', '34', 
'35', '36', '37', '38', '39')), 0),
StatementMinDue = ISNULL((SELECT SUM(CAST(TheData AS MONEY))
FROM MiscExtra me WITH (NOLOCK)
WHERE Number = @number AND SUBSTRING(title, 1, 2) IN ('50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '63', '64', '67', '69', '62')), 0),
statement180 = -(statementdue) + StatementMinDue + (SELECT original FROM master m WITH (NOLOCK) WHERE m.number = @number)
WHERE AccountID = @number

END
GO
