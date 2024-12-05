SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 01/20/2023
-- Description:	Exports reformatted placement file
-- Changes:		03/23/2023 BGM Added Order to Consumers portion so the debtors will load in sequence and prevent a Secondary as being the first records in the misc extra.
--				07/18/2023 BGM Count Equabli Placement files being sent with maintenance records in them by adding code for
--							sub records to look for an account record to create an entry in the placement file.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Placement_File_V34_BU]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Accounts
SELECT ceai.record_type, ceai.account_id, ceai.client_account_number, ceai.client_id, ceai.client_job_schedule_id, ceai.portfolio_code, ceai.original_lender_creditor, ceai.current_lender_creditor, 
ceai.original_account_number, ceai.additional_account_number, ceai.is_consent, ceai.customer_type, ceai.dt_original_account_open, ceai.dt_last_payment, ceai.amt_last_payment, ceai.dt_assigned, 
ceai.dt_delinquency, ceai.dt_charge_off, ceai.dt_last_purchase, ceai.dt_last_cash_advance, ceai.dt_last_balance_transfer, ceai.amt_post_charge_off_interest, ceai.amt_post_charge_off_fees, 
ceai.amt_post_charge_off_payment, ceai.amt_post_charge_off_credit, ceai.pct_post_charge_off_feerate, ceai.pct_post_charge_off_interest, ceai.amt_pre_charge_off_principle, ceai.amt_pre_charge_off_interest, 
ceai.pct_pre_charge_off_interest, ceai.amt_pre_charge_off_fees, ceai.amt_pre_charge_off_balance, ceai.pct_pre_charge_off_feerate, ceai.amt_assigned, ceai.amt_principal_assigned, ceai.amt_interest_assigned, 
ceai.amt_latefee_assigned, ceai.amt_otherfees_assigned, ceai.amt_last_purchase, ceai.amt_last_cash_advance, ceai.amt_last_balance_transfer, ceai.amt_courtcost_assigned, ceai.amt_attorneyfees_assigned, 
ceai.charge_off_reason_id, ceai.dt_last_contact_pre_c_o, ceai.dt_first_delinquency, ceai.is_military, ceai.is_scra, ceai.is_cease_desist, ceai.product_id, ceai.amt_post_chargeoff_unpaid_charges, 
ceai.dt_hold_term, ceai.amt_monthly_payment_before_charge, ceai.dt_statute, ceai.original_account_open_location, ceai.original_account_application_type, ceai.original_account_open_ip, ceai.is_debt_settled, 
ceai.product_affinity, ceai.debt_type, ceai.productsubtype_id 
FROM Custom_Equabli_Account_Info ceai WITH (NOLOCK)

--Consumers
SELECT ceci.record_type, ceci.account_id, ceci.client_account_number, ceci.client_id, ceci.client_consumer_number, ceci.consumer_id, ceci.contact_type, ceci.first_name, ceci.middle_name, ceci.last_name, ceci.business_name, ceci.contact_suffix, ceci.identification_number, ceci.dt_birth, ceci.dt_death, ceci.service_branch, ceci.is_military, ceci.dt_start_active_duty, ceci.dt_end_active_duty, ceci.contact_alias, ceci.dl_number, ceci.dl_state_code,
	ceai.address1, ceai.address2, ceai.city, ceai.county, ceai.state_code, ceai.zip, ceai.address_status, ceai.address_type, ceai.dt_address_update, ceai.is_primary AS is_primary_address,
	ceei.email_address, ceei.is_work, ceei.is_opt_out, ceei.is_valid, ceei.is_consent, ceei.dtm_consent, ceei.status_code, ceei.is_primary AS is_primary_email,
	ceei1.client_employer_number, ceei1.employer_id, ceei1.full_name AS empfull_name, ceei1.phone AS empphone, ceei1.address1 AS empaddress1, ceei1.address2 AS empaddress2, ceei1.state_code AS empstate_code, ceei1.city AS empcity, ceei1.zip AS empzip,
	cechi.communication_detail_id, cechi.communication_channel, cechi.communication_reason, cechi.communication_subreason, cechi.dt_communication, cechi.tm_utc_communication, cechi.communication_outcome, cechi.direction, cechi.disposition, cechi.details, cechi.pct_discount, cechi.is_rpc_received, cechi.dt_rpc, cechi.compliance_type AS compliance_type_comm, cechi.compliance_subtype AS compliance_subtype_comm, cechi.dt_compliance, cechi.compliance_id, cechi.dt_outcome, cechi.tm_utc_outcome, cechi.regulatorybody_short_name AS regulatorybody_short_name_comm, cechi.remark_comment AS remark_comment_comm,
	ceci1.compliance_type, ceci1.compliance_subtype, ceci1.description_reported, ceci1.dt_filing, ceci1.compliance_channel, ceci1.compliance_mode, ceci1.compliance_status, ceci1.description_resolution, ceci1.dt_resolution, ceci1.contact_details, ceci1.compliance_reason, ceci1.is_validation_required, ceci1.remark_comment, ceci1.dt_report, ceci1.regulatorybody_short_name, ceci1.dt_firstsla, ceci1.dt_lastsla, ceci1.case_file_number, ceci1.amt_principle, ceci1.amt_interest, ceci1.amt_fee, ceci1.amt_total, ceci1.court_city,
	ceori.request_number AS request_number_request, ceori.operation_requesttype, ceori.queuereason, ceori.description, ceori.request_source, ceori.request_source_id, ceori.dt_request, ceori.dt_fulfillment, ceori.request_status,
	ceori1.request_number, ceori1.response_source, ceori1.response_source_id, ceori1.response_status, ceori1.description, ceori1.dt_response
FROM Custom_Equabli_Consumer_Info ceci WITH (NOLOCK) LEFT OUTER JOIN Custom_Equabli_Address_Info ceai WITH (NOLOCK) ON ceci.consumer_id = ceai.consumer_id AND ceai.is_primary = 'Y'
LEFT OUTER JOIN Custom_Equabli_Email_Info ceei WITH (NOLOCK) ON ceci.consumer_id = ceei.consumer_id AND ceei.is_primary = 'Y'
LEFT OUTER JOIN Custom_Equabli_Employer_Info ceei1 WITH (NOLOCK) ON ceci.consumer_id = ceei1.consumer_id LEFT OUTER JOIN Custom_Equabli_CommunicationHistory_Info cechi WITH (NOLOCK) ON ceci.consumer_id = cechi.consumer_id
LEFT OUTER JOIN Custom_Equabli_Compliance_Info ceci1 WITH (NOLOCK) ON ceci.consumer_id = ceci1.consumer_id LEFT OUTER JOIN Custom_Equabli_OpRequest_Info ceori WITH (NOLOCK) ON ceci.consumer_id = ceori.consumer_id
LEFT OUTER JOIN Custom_Equabli_OpResponse_Info ceori1 WITH (NOLOCK) ON ceci.consumer_id = ceori1.consumer_id 
WHERE ceci.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)
ORDER BY ceci.account_id, ceci.contact_type, ceci.consumer_id

--Alt Address
SELECT '2Address' AS record_type, ceai.account_id, ceai.client_account_number, ceai.client_id, ceai.client_consumer_number, ceai.consumer_id, ceai.address1, ceai.address2, ceai.city, ceai.county, ceai.state_code, ceai.zip, ceai.address_status, ceai.address_type, ceai.dt_address_update, ceai.is_primary 
FROM Custom_Equabli_Address_Info ceai WITH (NOLOCK) 
WHERE ceai.is_primary = 'N' AND ceai.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--Phones
SELECT cepi.record_type, cepi.account_id, cepi.client_account_number, cepi.client_id, cepi.client_consumer_number, cepi.consumer_id, ceci.identification_number, cepi.phone, cepi.phone_type, cepi.is_wireless_indicator, cepi.is_primary, cepi.is_dnc, cepi.is_consent, cepi.dtm_consent, cepi.phone_status, cepi.dtm_phone_update
FROM Custom_Equabli_Phones_Info cepi WITH (NOLOCK) LEFT OUTER JOIN Custom_Equabli_Consumer_Info ceci WITH (NOLOCK)  ON cepi.consumer_id = ceci.consumer_id
WHERE ceci.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--SELECT cepi.record_type, cepi.account_id, cepi.client_account_number, cepi.client_id, cepi.client_consumer_number, cepi.consumer_id, ceci.identification_number, cepi.phone, cepi.phone_type, cepi.is_wireless_indicator, cepi.is_primary, cepi.is_dnc, cepi.is_consent, cepi.dtm_consent, cepi.phone_status, cepi.dtm_phone_update,
--	cedpi.phone, CASE WHEN cedpi.weekday_number = '1' THEN 'Sunday' ELSE '' END AS Exc_Sunday, CASE WHEN cedpi.weekday_number = '1' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Sunday_Start, CASE WHEN cedpi.weekday_number = '1' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Sunday_End,
--	CASE WHEN cedpi.weekday_number = '2' THEN 'Monday' ELSE '' END AS Exc_Monday, CASE WHEN cedpi.weekday_number = '2' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Monday_Start, CASE WHEN cedpi.weekday_number = '2' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Monday_End,
--	CASE WHEN cedpi.weekday_number = '3' THEN 'Tuesday' ELSE '' END AS Exc_Tuesday, CASE WHEN cedpi.weekday_number = '3' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Tuesday_Start, CASE WHEN cedpi.weekday_number = '3' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Tuesday_End,
--	CASE WHEN cedpi.weekday_number = '4' THEN 'Wednesday' ELSE '' END AS Exc_Wednesday, CASE WHEN cedpi.weekday_number = '4' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Wednesday_Start, CASE WHEN cedpi.weekday_number = '4' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Wednesday_End,
--	CASE WHEN cedpi.weekday_number = '5' THEN 'Thursday' ELSE '' END AS Exc_Thursday, CASE WHEN cedpi.weekday_number = '5' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Thursday_Start, CASE WHEN cedpi.weekday_number = '5' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Thursday_End,
--	CASE WHEN cedpi.weekday_number = '6' THEN 'Friday' ELSE '' END AS Exc_Friday, CASE WHEN cedpi.weekday_number = '6' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Friday_Start, CASE WHEN cedpi.weekday_number = '6' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Friday_End,
--	CASE WHEN cedpi.weekday_number = '7' THEN 'Saturday' ELSE '' END AS Exc_Saturday, CASE WHEN cedpi.weekday_number = '7' THEN cedpi.tm_excluded_from ELSE '' END AS Exc_Saturday_Start, CASE WHEN cedpi.weekday_number = '7' THEN cedpi.tm_excluded_to ELSE '' END AS Exc_Saturday_End
--FROM Custom_Equabli_Phones_Info cepi WITH (NOLOCK) LEFT OUTER JOIN Custom_Equabli_Consumer_Info ceci WITH (NOLOCK)  ON cepi.consumer_id = ceci.consumer_id
--LEFT OUTER JOIN Custom_Equabli_DialPreference_Info cedpi WITH (NOLOCK) ON cepi.consumer_id = cedpi.consumer_id AND cepi.phone = cedpi.phone AND CAST(cedpi.tm_excluded_from AS TIME) > '08:00' AND CAST(cedpi.tm_excluded_to AS TIME) < '10:00'
--ORDER BY cedpi.phone

--Alt Email
SELECT '2Email' AS record_type, ceei.account_id, ceei.client_account_number, ceei.client_id, ceei.client_consumer_number, ceei.consumer_id, ceei.email_address, ceei.is_work, ceei.is_opt_out, ceei.is_valid, ceei.is_consent, ceei.dtm_consent, ceei.status_code, ceei.is_primary
FROM Custom_Equabli_Email_Info ceei WITH (NOLOCK) 
WHERE ceei.is_primary = 'N' AND ceei.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--Email Preference
SELECT record_type, account_id, client_account_number, client_id, client_consumer_number, consumer_id, email_address, weekdayno, tm_utc_from, tm_utc_till	
FROM Custom_Equabli_EmlPreference_Info ceepi WITH (NOLOCK) 
WHERE ceepi.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--dial preference
SELECT record_type, account_id, client_account_number, client_id, client_consumer_number, consumer_id, phone, weekday_number, tm_excluded_from, tm_excluded_to 
FROM Custom_Equabli_DialPreference_Info cedpi WITH (NOLOCK) 
WHERE cedpi.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--sms preference
SELECT cesi.record_type, cesi.account_id, cesi.client_account_number, cesi.client_id, cesi.client_consumer_number, cesi.consumer_id, cesi.phone, cesi.weekday_number, cesi.tm_excluded_from, cesi.tm_excluded_to 
FROM Custom_Equabli_SMSPreference_Info cesi WITH (NOLOCK) 
WHERE cesi.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--Serviceing History
SELECT record_type, account_id, client_account_number, client_id, dt_last_call_outbound, last_phone_number, last_call_outcome, dt_last_call_inbound, dt_last_rpc, last_rpc_disposition, dt_last_letter_outbound, last_letter_outcome, pct_last_discount, dt_last_email_outbound, last_email_address, last_email_outcome, dt_last_sms_outbound, last_sms_number, last_sms_outcome, is_broken_settlement, dt_broken_settlement, dt_settlement_offer, count_settlements_offered, method_settlement, amt_payment_settlement
FROM Custom_Equabli_ServiceHistory_Info ceshi WITH (NOLOCK) 
WHERE ceshi.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--RankScore
SELECT cersi.record_type, cersi.account_id, cersi.client_account_number, cersi.client_id, cersi.partner_id, cersi.service_intensity_bucket, cersi.pct_max_discount, cersi.dt_score, cersi.priority_1_phone, cersi.priority_2_phone, cersi.priority_3_phone, cersi.priority_1_email, cersi.priority_2_email, cersi.client_latest_job_schedule_id 
FROM Custom_Equabli_RankScore_Info cersi WITH (NOLOCK) 
WHERE cersi.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--Statute
SELECT cesi.record_type, cesi.account_id, cesi.client_account_number, cesi.client_id, cesi.dt_statute 
FROM Custom_Equabli_Statute_Info cesi WITH (NOLOCK) 
WHERE cesi.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--ACStatusChange
SELECT ceasci.Record_Type, ceasci.account_id, ceasci.client_account_number, ceasci.client_id, ceasci.queue, ceasci.queue_status, ceasci.queue_reason 
FROM Custom_Equabli_AcStatusChange_Info ceasci WITH (NOLOCK) 
WHERE ceasci.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--ACAmountChange
SELECT ceaaci.Record_Type, ceaaci.account_id, ceaaci.client_account_number, ceaaci.client_id, ceaaci.amt_assigned 
FROM Custom_Equabli_AcAmountChange_Info ceaaci WITH (NOLOCK) 
WHERE ceaaci.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)

--Adjustment
SELECT record_type, account_id, client_account_number, client_id, partner_id, adjustment_type, dt_adjustment, amt_adjustment, amt_principal, amt_interest, amt_latefee, amt_otherfee, amt_courtcost, amt_attorneyfee 
FROM Custom_Equabli_Adjustment_Info ceai WITH (NOLOCK) 
WHERE ceai.account_id IN (SELECT account_id FROM Custom_Equabli_Account_Info)
END
GO
