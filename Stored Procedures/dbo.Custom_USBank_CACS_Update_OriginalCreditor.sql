SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 05/04/2020 BGM Removed the original creditor to use auto club instead of us bank.
-- 12/11/2020 BGM Added code in to calculate the Chargeoff amount to statement 180 and the payments post chargeoff to statementmindue
-- 11/10/2021 BGM Added code to insert L3_Line5 data from StatementMinDue ESD field.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Update_OriginalCreditor] 
	-- Add the parameters for the stored procedure here
	@number INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    -- removed due to moving to import new business in Exchange-- 03/31/21
--	UPDATE master
--SET OriginalCreditor = CASE WHEN id2 = '040102' THEN 'ELAN'
--	--WHEN id2 = '040101' AND (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'g01.0.correspondencename') IN ('AUTOCLUB TRUST FSB', 'AUTO CLUB TRUST FSB', 'AUTO CLUB TRUST FSB E')
--	--THEN 'ACG CARD SERVICES'
--	ELSE 'US BANK' END
--FROM master m WITH (NOLOCK)
--WHERE number = @number	

UPDATE dbo.EarlyStageData
--Calculate Chargeoff amount
SET statement180 = ISNULL((SELECT TOP 1 CONVERT(MONEY, ISNULL(thedata, 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'pla.0.principalamount'), 0)
+ ISNULL((SELECT TOP 1 CONVERT(MONEY, ISNULL(thedata, 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'pla.0.TotalFeesCosts'), 0)
+ ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - CR'), 0) 
- ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - DB'), 0) 
- ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - NG'), 0)
+ ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - PY'), 0) 
--calculate payments and credits after chargeoff
, StatementMinDue = ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - CR'), 0) 
- ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - DB'), 0) 
- ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - NG'), 0)
+ ISNULL((SELECT SUM(ISNULL(CONVERT(MONEY, REPLACE(thedata, LEFT(thedata, 11), '')), 0)) FROM dbo.MiscExtra WITH (NOLOCK) WHERE Number = @number and title = 'collection activity - PY'), 0) 
WHERE AccountID = @number

--update L3 extracode with payment information
UPDATE extradata
SET line5 = esd.statementmindue
FROM EarlyStageData esd WITH (NOLOCK) 
WHERE esd.AccountID = @number AND extracode = 'L3'
AND esd.AccountID = number

--Update L3 extracode with payment information if does not exist
INSERT INTO extradata	 (number, extracode, line1, line2, line3, line4, line5)
SELECT esd.AccountID, 'L3', '', '', '', '', esd.StatementMinDue
FROM EarlyStageData esd WITH (NOLOCK) 
WHERE esd.AccountID = @number
AND esd.AccountID NOT IN (SELECT number FROM extradata WITH (NOLOCK) WHERE number = esd.AccountID AND extracode = 'L3')


END
GO
