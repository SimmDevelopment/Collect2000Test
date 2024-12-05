SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:  08/05/2020 BGM - Changed query to look in the main inbound table instead of having to import data into a secondary table in order to save time.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_TF_Holdings_ECHO_Export_Placement_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   
	SELECT loan_series_number, customer_name, loan_balance, cure_amount, loan_series_create_date, last_payment_date, last_payment_amount, payment_due_date,
	days_past_due,	Phone_1_Type,	Phone_1, Phone_2_Type, Phone_2, Phone_3_Type, Phone_3, AcceptableStartTime, AcceptableEndTime,	TimeZone,
	Zipcode, CreditLimit,	PayFrequency, IsCovid, Address_1, Address_2, City, State


        FROM Custom_TF_Holdings_ECHO_Import_Active_Accounts ctfheiaa WITH (NOLOCK)
        Where ctfheiaa.loan_series_number NOT IN 
				(SELECT account
		FROM master WITH (NOLOCK)
		WHERE (closed IS NULL OR status IN ('pif', 'sif', 'cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd', 'dec', 'bky', 'b07', 'b11', 'b13'))
		AND (customer IN ('0003017')))

END
GO
