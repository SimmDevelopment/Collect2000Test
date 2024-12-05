SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/8/2020
-- Description:	Export Account Updates
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CitizensBank_DN_Account_Update] 
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
SELECT m.id1 AS data_id, 
'' AS data_military, 
'' AS data_ssi,
CASE WHEN d.seq = 0 THEN ah.NewStreet1 ELSE '' end as	pri_add1, 
CASE WHEN d.seq = 0 THEN ah.NewStreet2 ELSE '' end as	pri_add2, 
CASE WHEN d.seq = 0 THEN ah.NewCity ELSE '' end as	pri_city, 
CASE WHEN d.seq = 0 THEN ah.NewState ELSE '' end as	pri_state, 
CASE WHEN d.seq = 0 THEN ah.NewZipcode ELSE '' end as	pri_zip, 
'' AS pri_email,
'' AS pri_language
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE m.customer IN ('0001110', '0001111', '0001112') AND dbo.date(ah.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
