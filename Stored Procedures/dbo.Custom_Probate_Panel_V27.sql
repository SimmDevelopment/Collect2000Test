SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 2018
-- Description:	Gets form data for Probate templates
-- Changes:
--		BGM - 4/29/2019 - Added US Bank ACG line to Customername and original creditor field
--		BGM - 3/9/2020 - Adjusted US Bank ACG to only require looking at the original creditor field now.
--		BGM - 07/22/2021 - Changed verbage for customer name field for 1121, 1134 1188 to successor in interest to, from assignee of
--		BGM - 08/04/2022 - Updated commission date for Notary
--		BGM - 09/01/2022 - Added Notary Public field.
--	Version 2.7 Created 10/13/2022
--		BGM - 10/25/2022 - Added Wisconsin Claimant for their specific form to use with Resurgent.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Probate_Panel_V27] 
	-- Add the parameters for the stored procedure here
	@number int,
  @userid   int

--exec custom_probate_panel_V27 13816133             , 268

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select cp.ID, Case when [cmty prop] = 'CP' then 'YES' else 'NO' end as [CMTY PROP], 
	ISNULL(cp.court, 'NOT ENTERED') AS court, cp.Street1, cp.Street2, cp.City, CONVERT(VARCHAR(2), cp.state) AS [state], cp.zipcode,
	cp.county, cp.address, cp.TELEPHONE, upper(cp.action) as [Action], cp.Email, 
	cp.website, cp.notes, cp.[claim fee], cp.[search fee], cp.[covered areas], s.Description AS fullstate,
	CASE WHEN m.customer IN ('0001749') AND (d.middlename <> '' OR d.middlename IS NOT NULL) THEN d.firstName + ' ' + d.middleName + ' ' + d.lastName + CASE WHEN d.suffix IS NOT NULL THEN ' ' + ISNULL(d.suffix, '') ELSE '' END ELSE d.firstName + ' ' + d.lastName + ISNULL(d.suffix, '') end AS FirstNameFirst, dec.CaseNumber, 
	CASE WHEN m.customer IN ('0001121', '0001134', '0001188', '0001549', '0000101') THEN m.PreviousCreditor + ' successor in interest to ' + m.OriginalCreditor 
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'US Bank' THEN 'U.S. Bank National Association' 
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'ELAN' THEN 'U.S. Bank National Association dba Elan Financial Services' 
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'ACG Card Services' THEN 'US Bank National Association dba ACG Card Services' 	 
		ELSE c.Name end AS customername,
	c.Street1 AS customerstreet1, c.street2 AS customerstreet2, c.City AS customercity, c.State AS customerstate, c.Zipcode AS customerzip,
	CASE WHEN m.customer IN ('0001219', '0001220') THEN c.name 
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'US Bank' THEN 'U.S. Bank National Association' 
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'ELAN' THEN 'U.S. Bank National Association dba Elan Financial Services' 
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'ACG Card Services' THEN 'US Bank National Association dba ACG Card Services'
		ELSE m.OriginalCreditor END AS OriginalCreditor, 
	CASE WHEN m.customer IN ('0001121', '0001134', '0001188', '0001549', '0000101') THEN m.PreviousCreditor + ' successor in interest to ' + m.OriginalCreditor 
		WHEN m.customer IN ('0001219', '0001220') THEN c.name + ' C/O Simm Associates, Inc.'
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'US Bank' THEN 'U.S. Bank National Association' + ' C/O Simm Associates, Inc.'
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'ELAN' THEN 'U.S. Bank National Association dba Elan Financial Services' + ' C/O Simm Associates, Inc.'
		WHEN m.customer IN ('0001749') AND m.originalcreditor = 'ACG Card Services' THEN 'US Bank National Association dba ACG Card Services' + ' C/O Simm Associates, Inc.'
		ELSE m.OriginalCreditor + ' C/O Simm Associates, Inc.' END AS WisconsinClaimant,		
	CASE WHEN m.customer IN ('0001220') THEN '' WHEN m.customer IN ('0001749') THEN 'Unsecured' ELSE m.PreviousCreditor END AS PreviousCreditor, 
	m.account, CONVERT(VARCHAR(10), m.ContractDate, 101) AS [ContractDate], '$' + CONVERT(VARCHAR(16), m.current0, 1) AS [current],
	dec.Executor, dec.ExecutorStreet1, dec.executorstreet2, dec.ExecutorCity, dec.ExecutorState, dec.ExecutorZipcode, dbo.StripNonDigits(dec.ExecutorPhone) AS ExecutorPhone,
	da.name AS attyname, da.addr1 AS attyaddr1, da.addr2 AS attyaddr2, da.City AS attycity, da.State AS attystate, da.Zipcode AS attyzipcode,
	dbo.StripNonDigits(da.Phone) AS attyphone, m.number, d.Street1 AS dbstreet1, d.Street2 AS dbstreet2, d.City AS dbcity, d.State AS dbstate, d.Zipcode AS dbzip,
	'Danielle M. Gibbs' AS NotaryPublic, '4/30/2023' AS commission, CONVERT(VARCHAR(10), dec.DOD, 101) AS DOD, 'XXX-XX-' + RIGHT(d.ssn, 4) AS SSN
	from debtors d with (nolock) inner join custom_probate_court_info cp with (Nolock) on d.county = cp.county and d.state = cp.state
	INNER JOIN states s WITH (NOLOCK) ON d.state = s.Code LEFT OUTER JOIN dbo.Deceased dec WITH (NOLOCK) ON d.DebtorID = dec.DebtorID
	INNER JOIN master m WITH (NOLOCK) ON d.number = m.number INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	LEFT OUTER JOIN dbo.DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
	where d.number = @number and d.seq = 0
	
	SELECT CASE WHEN id in (2219) THEN RoleID WHEN roleid = 31 THEN 2 ELSE RoleID END AS RoleID
	FROM users WITH (NOLOCK)
	WHERE id = @userid

END


GO
