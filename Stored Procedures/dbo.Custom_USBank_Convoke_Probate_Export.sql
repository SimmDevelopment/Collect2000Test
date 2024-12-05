SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Convoke_Probate_Export]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT m.account AS AccountNumber, CONVERT(VARCHAR(10), m.number) AS ExternalUniqueIdentifier, ISNULL(CONVERT(VARCHAR(10), d2.dod, 120), '') AS DateofDeath, ISNULL(CONVERT(VARCHAR(10), d.dob, 120), CONVERT(VARCHAR(10), d2.dob, 120)) AS DateOfBirth,
m.original AS DateOfDeathBalanceAmount, m.number AS ClaimNumber,
ISNULL(CONVERT(VARCHAR(10), m.userdate2, 120), CONVERT(VARCHAR(10), sh.DateChanged, 120)) AS IssuerDateOfClaim, ISNULL(CONVERT(VARCHAR(10), m.userdate2, 120), '') AS ClaimDate, d.County AS County, d.State AS STATE,
COALESCE(da.Name, d2.Executor) AS AttorneyName, ISNULL(d2.courtdistrict, '') + ISNULL(d2.CourtDivision, '') AS CourtName, d2.CaseNumber AS ProbateCaseNumber,
'simmsa' AS PartnerIdentifier, '' AS AuthorizedRepresentative, m.OriginalCreditor AS CreditorName,
'Unsecured' AS TypeOfClaim, '' AS NotaryName, d.SSN AS ProbateSSN, d.firstName AS ProbateFirstName, '' AS ProbateMiddleName,
d.lastName AS ProbateLastName, '' AS ProbateSuffix, d.Street1 AS ProbateAddressLine1, d.Street2 AS ProbateAddressLine2,
d.City AS ProbateCity, d.State AS ProbateState, REPLACE(d.Zipcode, '-', '') AS ProbateZipCode
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE customer = '0001063' --'0001749' 
AND status = 'pcm' --AND m.userdate2 BETWEEN @startDate AND @endDate
AND sh.NewStatus = 'pcm' AND sh.DateChanged BETWEEN @startDate AND @endDate
END
GO
