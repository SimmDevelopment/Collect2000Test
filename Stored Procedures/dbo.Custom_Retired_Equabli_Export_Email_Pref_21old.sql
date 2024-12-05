SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/30/2023
-- Description:	Export Email Preferences to load on accounts
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Retired_Equabli_Export_Email_Pref_21old]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'emlprefs' AS record_type
	, D.number AS number	
	, d.debtorid AS debtorid
	, 'emlID.' + CAST(e.emailid AS VARCHAR) + '.ConID' AS METitleConID
	, ceeph.consumer_id AS consumer_id
	, 'emlID.' + CAST(e.emailid AS VARCHAR) + '.Addr' AS METitleEmailAddr
	, ceeph.email_address AS email_address
	, 'emlID.' + CAST(e.emailid AS VARCHAR) + '.day.' + ceeph.weekdayno + '.TM_From' AS METitleFromTime
	, ceeph.tm_utc_from AS tm_utc_from
	, 'emlID.' + CAST(e.emailid AS VARCHAR) + '.day.' + ceeph.weekdayno + '.TM_Till' AS METitleTillTime
	, ceeph.tm_utc_till AS tm_utc_till
FROM debtors d WITH (NOLOCK) INNER JOIN email e ON D.debtorid = e.debtorid
INNER JOIN custom_equabli_emlpreference_history ceeph WITH (NOLOCK) ON CONVERT(VARCHAR(20), D.debtormemo) = ceeph.consumer_id

END
GO
