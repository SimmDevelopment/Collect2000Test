SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/23/2023
-- Description:	Export Consumer information for Equabli
-- Changes:		03/24/2023 BGM Added start date end date for Received date and added separate table to supply the UTC Date
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Retired_Equabli_Export_Consumer_3old]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate
	
    -- Insert statements for procedure here
	SELECT 'consumer' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, CASE WHEN D.seq = 0 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.client_consumer_number') 
			WHEN d.seq = 1 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.1.client_consumer_number') 
			WHEN d.seq = 2 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.2.client_consumer_number') END AS client_consumer_number
	, d.DebtorMemo AS consumer_id
	, CASE WHEN D.seq = 0 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.contact_type') 
			WHEN d.seq = 1 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.1.contact_type')
			WHEN d.seq = 2 THEN (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.2.contact_type') END AS contact_type
	, ISNULL(d.firstName, '') AS first_name
	, ISNULL(d.middleName, '') AS middle_name
	, ISNULL(d.lastName, '') AS last_name
	, ISNULL(d.businessName, '') AS business_name
	, ISNULL(d.suffix, '') AS contact_suffix
	, ISNULL(d.SSN, '') AS identification_number
	, FORMAT(d.DOB, 'yyyy-MM-dd') AS dt_birth
	, CASE WHEN status = 'DEC' THEN (SELECT TOP 1 FORMAT(DOD, 'yyyy-MM-dd') FROM deceased WITH (NOLOCK) WHERE DebtorID = d.DebtorID) ELSE '' END AS dt_death
	, '' AS service_branch
	, CASE WHEN status = 'MIL' THEN 'Y' ELSE 'N' END AS is_military
	, CASE WHEN status = 'MIL' THEN (SELECT TOP 1 FORMAT(csh.ActiveDutyBeginDate, 'yyyy-MM-dd') FROM Custom_SCRA_History csh WITH (NOLOCK) WHERE csh.DebtorID = D.debtorid ) ELSE '' END AS dt_start_active_duty
	, CASE WHEN status = 'MIL' THEN (SELECT TOP 1 FORMAT(csh.ActiveDutyEndDate, 'yyyy-MM-dd') FROM Custom_SCRA_History csh WITH (NOLOCK) WHERE csh.DebtorID = D.debtorid ) ELSE '' END AS dt_end_active_duty
	, '' AS contact_alias
	, CASE WHEN SUBSTRING(D.DLNum, 1, 2) IN (SELECT code FROM states WITH (NOLOCK) ) THEN SUBSTRING(D.dlnum, 4, LEN(d.DLNum)) ELSE '' END AS dl_number
	, CASE WHEN SUBSTRING(D.DLNum, 1, 2) IN (SELECT code FROM states WITH (NOLOCK) ) THEN SUBSTRING(D.DLNum, 1, 2) ELSE '' END AS dl_state_code
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
WHERE m.customer IN (Select customerid from fact where customgroupid = 381) 
AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND status IN ('DEC', 'MIL')

END
GO
