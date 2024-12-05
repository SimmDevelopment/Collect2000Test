SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/8/2020
-- Description:	Export Account Updates
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ARC_Account_Update] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME, 
	@endDate DATETIME
AS

--exec custom_citizensbank_dn_account_update '20200503', '20200503'

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Address change
SELECT m.id2 AS data_id, 
'' AS data_military, 
'' AS data_ssi,
CASE WHEN d.seq = 0 THEN ah.NewStreet1 ELSE '' end as	pri_add1, 
CASE WHEN d.seq = 0 THEN ah.NewStreet2 ELSE '' end as	pri_add2, 
CASE WHEN d.seq = 0 THEN ah.NewCity ELSE '' end as	pri_city, 
CASE WHEN d.seq = 0 THEN ah.NewState ELSE '' end as	pri_state, 
CASE WHEN d.seq = 0 THEN ah.NewZipcode ELSE '' end as	pri_zip, 
'' as	pri_hphone,
'' AS pri_driverlicense,
'' AS pri_driverlicense_state,
'' AS pri_dob,
'' AS pri_cphone,
'' AS pri_email,
'' AS pri_ophone,
'' AS pri_wphone,
'' AS pri_attorney_company,
'' AS pri_attorney_name,
'' AS pri_attorney_add1,
'' AS pri_attorney_add2,
'' AS pri_attorney_city,
'' AS pri_attorney_state,
'' AS pri_attorney_zip,
'' AS pri_attorney_phone,
CASE d.language
--WHEN '0003 - OTHER' THEN
WHEN '0001 - ENGLISH' THEN 'en'
WHEN '0002 - SPANISH' THEN 'es'
WHEN '0004 - ARABIC' THEN 'ar'
WHEN '0005 - ARMENIAN' THEN 'hy'
WHEN '0006 - CHINESE' THEN 'zh'
--WHEN '0007 - FILIPINO' THEN 
WHEN '0008 - FRENCH' THEN 'fr'
WHEN '0009 - GERMAN' THEN 'de'
WHEN '0010 - GREEK' THEN 'el'
WHEN '0011 - HEBREW' THEN 'he'
WHEN '0012 - HINDI' THEN 'hi'
WHEN '0013 - INDONESIAN' THEN 'id'
WHEN '0014 - ITALIAN' THEN 'it'
WHEN '0015 - JAPANESE' THEN 'ja'
WHEN '0016 - KOREAN' THEN 'ko'
WHEN '0017 - PERSIAN' THEN 'fa'
WHEN '0018 - POLISH' THEN 'pl'
WHEN '0019 - PORTUGUESE' THEN 'pt'
WHEN '0020 - RUSSIAN' THEN 'ru'
WHEN '0021 - TAGALOG' THEN 'tl'
WHEN '0022 - VIETNAMESE' THEN 'vi'
WHEN '0023 - YIDDISH' THEN 'yi'
--WHEN '0024 - NOT VERIFIED' THEN 
WHEN '0025 - BENGALI' THEN 'bn'
WHEN '0026 - CZECH' THEN 'cs'
--WHEN '0027 - MANDARIN' THEN 
WHEN '0028 - ESTONIAN' THEN 'et'
WHEN '0029 - CREOLE' THEN 'ht'
WHEN '0030 - LITHUANIAN' THEN 'lt'
--WHEN '0031 - FARSI' THEN
WHEN '0032 - ALBANIAN' THEN 'sq'
--WHEN '0033 - CANTONESE' THEN 
ELSE ''
end AS pri_language,
CASE WHEN d.seq = 1 THEN ah.NewStreet1 ELSE '' end as	sec_add1, 
CASE WHEN d.seq = 1 THEN ah.NewStreet2 ELSE '' end as	sec_add2, 
CASE WHEN d.seq = 1 THEN ah.NewCity ELSE '' end as	sec_city, 
CASE WHEN d.seq = 1 THEN ah.NewState ELSE '' end as	sec_state, 
CASE WHEN d.seq = 1 THEN ah.NewZipcode ELSE '' end as	sec_zip, 
'' as	sec_hphone,
'' AS sec_dob,
'' AS sec_cphone,
'' AS sec_email,
'' AS sec_ophone,
'' AS sec_wphone,
'' AS com_subservicer
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq in ('0','1') INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE m.customer IN ('0003098') AND dbo.date(ah.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
