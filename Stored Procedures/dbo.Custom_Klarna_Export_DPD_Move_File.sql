SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 01/23/2017
-- Description:	Create file to movve accounts to customer 1787 when reaching certain days past due
-- Changes:		11/16/2021 added new itemization fields for Reg F
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Klarna_Export_DPD_Move_File] 
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(10)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @dpd INT

	
	SET @dpd = CASE WHEN @customer = '0001787' THEN 60 ELSE 180 END

    -- Insert statements for procedure here
	SELECT m.account AS account_number, (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.date_sent') AS date_sent,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.date_account_opened') AS date_account_opened,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.date_delinquent') AS date_delinquent,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.dd') AS dd,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.delinquency_counter') AS delinquency_counter,
esd.SubStatuses AS days_delinquent,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.principal_remaining') AS principal_remaining,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.fees') AS fees,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.interest') AS interest,
current1 AS total_balance,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.billing_fname') AS billing_fname,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.billing_lname') AS billing_lname,
m.street1 AS billing_address, m.city AS billing_city, m.state AS billing_state, m.Zipcode AS billing_zip,
m.homephone AS phone,
ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.merchant_name'), (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.merchant')) AS merchant_name,
(SELECT TOP 1 email FROM Debtors WITH (NOLOCK) WHERE number = m.number AND seq = 0) AS email,
m.dob AS dob,
m.ssn AS ssn,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.itemization_date') AS itemization_date,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.itemization_remaining_principal') AS itemization_remaining_principal,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.itemization_remaining_fees') AS itemization_remaining_fees,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.itemization_remaining_interest') AS itemization_remaining_interest


FROM master m WITH (NOLOCK) INNER JOIN EarlyStageData esd WITH (NOLOCK) ON m.number = esd.AccountID 
WHERE customer = @customer AND closed IS NULL AND CONVERT(INT, esd.SubStatuses) > @dpd

END
GO
