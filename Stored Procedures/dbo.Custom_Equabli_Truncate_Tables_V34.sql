SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 10/11/2022
-- Description:	Truncates Temp Tables Prior to Loading New Data
-- Changes:		11/16/2023 Updated to Version 3.4
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Truncate_Tables_V34]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_Equabli_Account_Info
	TRUNCATE TABLE Custom_Equabli_Consumer_Info
	TRUNCATE TABLE Custom_Equabli_Address_Info
	TRUNCATE TABLE Custom_Equabli_Phones_Info
	TRUNCATE TABLE Custom_Equabli_Email_Info
	TRUNCATE TABLE Custom_Equabli_Employer_Info
	TRUNCATE TABLE Custom_Equabli_ServiceHistory_Info
	TRUNCATE TABLE Custom_Equabli_CommunicationHistory_Info
	TRUNCATE TABLE Custom_Equabli_RankScore_Info
	TRUNCATE TABLE Custom_Equabli_Payment_Info
	TRUNCATE TABLE Custom_Equabli_Compliance_Info
	TRUNCATE TABLE Custom_Equabli_OpRequest_Info
	TRUNCATE TABLE Custom_Equabli_OpResponse_Info
	TRUNCATE TABLE Custom_Equabli_EmlPreference_Info
	TRUNCATE TABLE Custom_Equabli_DialPreference_Info
	TRUNCATE TABLE Custom_Equabli_SMSPreference_Info
	TRUNCATE TABLE Custom_Equabli_Statute_Info
	TRUNCATE TABLE Custom_Equabli_AcStatusChange_Info
	TRUNCATE TABLE Custom_Equabli_AcAmountChange_Info
	TRUNCATE TABLE Custom_Equabli_Adjustment_Info
	TRUNCATE TABLE Custom_Equabli_Asset_Info
	TRUNCATE TABLE Custom_Equabli_ChangeLog_Info
	TRUNCATE TABLE Custom_Equabli_Cost_Info
	TRUNCATE TABLE Custom_Equabli_CreditScore_Info
	TRUNCATE TABLE Custom_Equabli_PartnerRank_Info
	TRUNCATE TABLE Custom_Equabli_UCC_Info

END
GO
