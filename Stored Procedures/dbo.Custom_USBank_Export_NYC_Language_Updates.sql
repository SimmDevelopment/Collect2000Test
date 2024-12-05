SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 10/15/2020
-- Description:	Will send accounts that are in NYC and have changed their preferred language and that language code to USB 
-- Changes:		10/16/2020 BGM Updated where clause to match text debtor number to sequence debtor, switched sides of math performed.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_NYC_Language_Updates] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = @CustGroupID --Production
SET @CustGroupID = 113 --Test	

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

    -- Insert statements for procedure here
	SELECT 'SIMM' AS [Agency Name], m.account AS [Account Number], d.DebtorMemo AS [CONTACT-ID], 
CASE LEFT(language, 4)	
	WHEN '0004' THEN 'AR'
	WHEN '0025' THEN 'BE'
	WHEN '0026' THEN 'CE'
	WHEN '0027' THEN 'CM'
	WHEN '0009' THEN 'DE'
	WHEN '0010' THEN 'EL'
	WHEN '0001' THEN 'EN'
	WHEN '0028' THEN 'ES'
	WHEN '0008' THEN 'FR'
	WHEN '0029' THEN 'HA'
	WHEN '0012' THEN 'HI'
	WHEN '0005' THEN 'HY'
	WHEN '0014' THEN 'IT'
	WHEN '0015' THEN 'JP'
	WHEN '0016' THEN 'KO'
	WHEN '0030' THEN 'LI'
	WHEN '0018' THEN 'PO'
	WHEN '0019' THEN 'PT'
	WHEN '0031' THEN 'PR'
	WHEN '0020' THEN 'RU'
	WHEN '0002' THEN 'SP'
	WHEN '0032' THEN 'SQ'
	WHEN '0021' THEN 'TG'
	WHEN '0022' THEN 'VI'
	WHEN '0033' THEN 'YU'
	WHEN '0003' THEN 'ZX'
	WHEN '0024' THEN 'UN'
	ELSE 'ZX'	
	 
END AS [Language Preference Code]
,n.comment
FROM dbo.master m WITH (NOLOCK) INNER JOIN dbo.notes n WITH (NOLOCK)  ON m.number = n.number
INNER JOIN dbo.Debtors d ON m.number = d.Number
WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND n.created BETWEEN @startDate AND @endDate
AND action = '+++++' AND result = '+++++'
AND user0 NOT IN ('system', 'exchange', 'sys', 'workflow')
AND CONVERT(VARCHAR(255), n.comment) LIKE '%language was%'
AND d.Zipcode IN (SELECT * FROM dbo.Custom_NYC_Zipcodes cnz WITH (NOLOCK) )
AND SUBSTRING(CONVERT(VARCHAR(255), comment), 8, 1)  = CONVERT(VARCHAR(1), d.seq + 1)


END
GO
