SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LINK_BD_Demo_Update] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Get Phones
	SELECT DISTINCT m.id1 AS [AccountID], 'SAI' AS [VendorID], 
	CASE WHEN ph.Phonetype = '1' THEN ph.NewNumber ELSE '' end AS [Phone1],
	CASE WHEN ph.Phonetype = '1' THEN 'HOME' END AS [Phone1Type],
	CASE WHEN ph.Phonetype = '2' THEN ph.NewNumber ELSE '' END AS [Phone2],
	CASE WHEN ph.Phonetype = '2' THEN 'WORK' END AS [Phone2Type],
	CASE WHEN ph.Phonetype = '3' THEN ph.NewNumber ELSE '' END AS [Phone3],
	CASE WHEN ph.Phonetype = '3' THEN 'MOBILE' END AS [Phone3Type],
	CASE WHEN ph.Phonetype = '27' THEN ph.NewNumber ELSE '' END AS [Phone4],
	CASE WHEN ph.Phonetype = '27' THEN 'ATTY' END AS [Phone4Type],
	'' AS [Address1],
	'' AS [Address2],
	'' AS [City1],
	'' AS [State1],
	'' AS [Zip1],
	d.lastName AS [Guarantor_Last_Name],
	d.firstName AS [Guarantor_First_Name],
	d.middleName AS [Guarantor_Middle_Initial],
	FORMAT(m.DOB, 'MM/dd/yyyy') AS [Guarantor_DOB],
	m.SSN AS [Guarantor SSN],
	'' AS [PatientLastName],
	'' AS [PatientFirstName],
	'' AS [PatientMiddleInit],
	'' AS [PatientDoB],
	'' AS [PatientSSN],
	d.Email AS [Guarantor_Email],
	'' AS [Patient Email],
	'' AS [Preferred Contact Method]
	FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
	INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
	INNER JOIN Phones_Master pm WITH (NOLOCK)  ON  pm.Number = m.number
	WHERE customer IN ('0003115') AND NewNumber <> ''
	AND closed IS NULL --AND m.number = '3259113'
	AND (CAST(pm.DateAdded AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND pm.LoginName <> 'SYNC' 
			OR CAST(pm.LastUpdated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
--AND dbo.date(ph.DateChanged) BETWEEN dbo.date('20241001') AND dbo.date('20241122')

--INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
--WHERE customer IN ('0003115') AND NewNumber <> ''
--AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
	
	UNION all
	
	--Get Address Changes
	SELECT m.id1 AS [AccountID], 'SAI' AS [VendorID], 
	'' AS [Phone1],
	'' AS [Phone1Type],
	'' AS [Phone2],
	'' AS [Phone2Type],
	'' AS [Phone3],
	'' AS [Phone3Type],
	'' AS [Phone4],
	'' AS [Phone4Type],
	ah.NewStreet1 AS [Address1],
	ah.NewStreet2 AS [Address2],
	ah.NewCity AS [City1],
	ah.NewState AS [State1],
	ah.NewZipcode AS [Zip1],
	d.lastName AS [Guarantor_Last_Name],
	d.firstName AS [Guarantor_First_Name],
	d.middleName AS [Guarantor_Middle_Initial],
	FORMAT(m.DOB, 'MM/dd/yyyy') AS [Guarantor DOB],
	m.SSN AS [Guarantor SSN],
	'' AS [PatientLastName],
	'' AS [PatientFirstName],
	'' AS [PatientMiddleInit],
	'' AS [PatientDoB],
	'' AS [PatientSSN],
	d.Email AS [Guarantor_Email],
	'' AS [Patient Email],
	'' AS [Preferred Contact Method]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0003115')
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL

	--Get Email Address Updates
	SELECT  DISTINCT m.id1 AS [AccountID], 'SAI' AS [VendorID], 
	'' AS [Phone1],
	'' AS [Phone1Type],
	'' AS [Phone2],
	'' AS [Phone2Type],
	'' AS [Phone3],
	'' AS [Phone3Type],
	'' AS [Phone4],
	'' AS [Phone4Type],
	'' AS [Address1],
	'' AS [Address2],
	'' AS [City1],
	'' AS [State1],
	'' AS [Zip1],
	d.lastName AS [Guarantor_Last_Name],
	d.firstName AS [Guarantor_First_Name],
	d.middleName AS [Guarantor_Middle_Initial],
	FORMAT(m.DOB, 'MM/dd/yyyy') AS [Guarantor DOB],
	m.SSN AS [Guarantor SSN],
	'' AS [PatientLastName],
	'' AS [PatientFirstName],
	'' AS [PatientMiddleInit],
	'' AS [PatientDoB],
	'' AS [PatientSSN],
	d.Email AS [Guarantor_Email],
	'' AS [Patient Email],
	'' AS [Preferred Contact Method]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
--INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0003115')
AND closed IS NULL 
AND CAST(d.DateUpdated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	
END

GO
