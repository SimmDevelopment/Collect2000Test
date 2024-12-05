SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 10/30/2023
-- Description:	Export Return File to Pendrick
--   exec custom_pendrick_agency_payments 23394, '20231031', '20231102'
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Pendrick_Skiptrace]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME
  , @endDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT DISTINCT
	'09' AS [Record_Type]
   , m.id1 AS [PCP_Unique_ID]
   , m.homephone AS [Phone_Number_1]
   , m.Name AS [Name_1]
   , d.Street1 AS [Address_1]
   , 'N' AS [Type_1]
   , CASE WHEN pm.PhoneStatusID = 2 THEN '0' WHEN pm.PhoneStatusID = 1 THEN '8' END AS [Status_1]
   , 'N' AS [Source_1]
   , REPLACE(CONVERT(VARCHAR(10), ph.DateChanged, 101),'/','') AS [Date_Received_1]
   , '' AS [Date_Last_1]
   , '0' AS [Switch_Type_1]
   , '0' AS [Consent_Type_1]
   , '0' AS [Usage_Type_1]
   , '' AS [Zip_1]
   , '' AS [Id_1]
   , '' AS [Phone_Number_2]
   , '' AS [Name_2]
   , '' AS [Address_2]
   , '' AS [Type_2]
   , '' AS [Status_2]
   , '' AS [Source_2]
   , '' AS [Date_Received_2]
   , '' AS [Date_Last_2]
   , '' AS [Switch_Type_2]
   , '' AS [Consent_Type_2]
   , '' AS [Usage_Type_2]
   , '' AS [Zip_2]
   , '' AS [Id_2]
   , '' AS [Phone_Number_3]
   , '' AS [Name_3]
   , '' AS [Address_3]
   , '' AS [Type_3]
   , '' AS [Status_3]
   , '' AS [Source_3]
   , '' AS [Date_Received_3]
   , '' AS [Date_Last_3]
   , '' AS [Switch_Type_3]
   , '' AS [Consent_Type_3]
   , '' AS [Usage_Type_3]
   , '' AS [Zip_3]
   , '' AS [Id_3]
   , '' AS [Phone_Number_4]
   , '' AS [Name_4]
   , '' AS [Address_4]
   , '' AS [Type_4]
   , '' AS  [Status_4]
   , '' AS [Source_4]
   , '' AS [Date_Received_4]
   , '' AS [Date_Last_4]
   , '' AS [Switch_Type_4]
   , '' AS [Consent_Type_4]
   , '' AS [Usage_Type_4]
   , '' AS [Zip_4]
   , '' AS [Id_4]
   , '' AS [Phone_Number_5]
   , '' AS [Name_5]
   , '' AS [Address_5]
   , '' AS [type_5]
   , '' AS [Status_5]
   , '' AS [Source_5]
   , '' AS [Date_Received_5]
   , '' AS [Date_Last_5]
   , '' AS [Switch_Type_5]
   , '' AS [Usage_Type_5]
   , '' AS [Zip_5]
   , '' AS [Id_5]
   , '' AS [Control_Number]

	FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
	INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
	INNER JOIN Phones_Master pm WITH (NOLOCK)  ON  pm.Number = m.number
	WHERE customer IN ('0003099') --AND NewNumber <> ''
    AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

	UNION ALL

	SELECT DISTINCT
	'09' AS [Record_Type]
   , m.id1 AS [PCP_Unique_ID]
   , da.Phone AS [Phone_Number_1]
   , da.Name AS [Name_1]
   , da.Addr1 + ' ' + da.City + ', ' + da.State AS [Address_1]
   , 'T' AS [Type_1]
   , '0' AS [Status_1]
   , 'N' AS [Source_1]
   , REPLACE(CONVERT(VARCHAR(10), DateChanged, 101),'/','') AS [Date_Received_1]
   , '' AS [Date_Last_1]
   , '0' AS [Switch_Type_1]
   , '0' AS [Consent_Type_#1]
   , '0' AS [Usage_Type_1 ]
   , da.Zipcode AS [Zip_1]
   , '' AS [Id_1]
   , '' AS [Phone_Number_2]
   , '' AS [Name_2]
   , '' AS [Address_2]
   , '' AS [Type_2]
   , '' AS [Status_2]
   , '' AS [Source_2]
   , '' AS [Date_Received_2]
   , '' AS [Date_Last_2]
   , '' AS [Switch_Type_2]
   , '' AS [Consent_Type_2]
   , '' AS [Usage_Type_2]
   , '' AS [Zip_2]
   , '' AS [Id_2]
   , '' AS [Phone_Number_3]
   , '' AS [Name_3]
   , '' AS [Address_3]
   , '' AS [Type_3]
   , '' AS [Status_3]
   , '' AS [Source_3]
   ,''  AS [Date_Received_3]
   , '' AS [Date_Last_3]
   , '' AS [Switch_Type_3]
   , '' AS [Consent_Type_3]
   , '' AS [Usage_Type_3]
   , '' AS [Zip_3]
   , '' AS [Id_3]
   , '' AS [Phone_Number_4]
   , '' AS [Name_4]
   , '' AS [Address_4]
   , '' AS [Type_4]
   , '' AS [Status_4]
   , '' AS [Source_4]
   , '' AS [Date_Received_4]
   , '' AS [Date_Last_4]
   , '' AS [Switch_Type_4]
   , '' AS [Consent_Type_4]
   , '' AS [Usage_Type_4]
   , '' AS [Zip_4]
   , '' AS [Id_4]
   , '' AS [Phone_Number_5]
   , '' AS [Name_5]
   , '' AS [Address_5]
   , '' AS [type_5]
   , '' AS [Status_5]
   , '' AS [Source_5]
   , '' AS [Date_Received_5]
   , '' AS [Date_Last_5]
   , '' AS [Switch_Type_5]
   , '' AS [Usage_Type_5]
   , '' AS [Zip_5]
   , '' AS [Id_5]
   , '' AS [Control_Number]

	FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number --AND d.seq <> 0
	INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
	--FROM master m WITH (NOLOCK) INNER JOIN dbo.AddressHistory a WITH (NOLOCK) ON m.number = a.AccountID
	INNER JOIN dbo.DebtorAttorneys da WITH (NOLOCK) ON m.number = da.AccountID
	--INNER JOIN Phones_Master pm WITH (NOLOCK)  ON m.number = pm.Number
	AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
		  --AND status NOT IN ('PIF')

END
GO
