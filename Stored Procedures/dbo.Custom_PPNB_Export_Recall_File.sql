SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:  08/05/2020 BGM - Changed query to look in the main inbound table instead of having to import data into a secondary table in order to save time.
--			 08/03/2021 BGM - Changed to return File number instead of account for new interface due to issues with recalling same account numbers in different customers.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_PPNB_Export_Recall_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--New feeds off main import table Custom_PayPal_NB_Inbound_File		
--Removed intermediate table Custom_PPNB_Import_Active_Accounts 
--added lookup of accounts to use from Custom_PayPal_NB_Inbound_File table instead	
	SELECT number 
	FROM master m WITH (NOLOCK) 
	WHERE account NOT IN (SELECT CUSTOMER_ACCOUNT_ID FROM Custom_PayPal_NB_Inbound_File cppnif WITH (NOLOCK) WHERE CUSTOMER_ACCOUNT_ID NOT IN (
SELECT ACCT_ID
FROM Custom_PayPal_NB_Post_CO_Master cppnpcm WITH (NOLOCK))
) and customer IN ('0002337','0002338')AND closed IS NULL

    -- Old
--	SELECT account 
--	FROM master m WITH (NOLOCK) 
--	WHERE account NOT IN (SELECT CUSTOMER_ACCOUNT_ID FROM Custom_PPNB_Import_Active_Accounts cpiaa WITH (NOLOCK) 
--) and customer IN ('0002337','0002338')AND closed IS NULL


END
GO
