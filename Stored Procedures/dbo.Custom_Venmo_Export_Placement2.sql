SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[Custom_Venmo_Export_Placement2]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account_id , sender_user_Name,date_created,sender_state,sender_social_score,amounts_owed, first_name ,last_name ,phone ,email , payment_date, receiver_user_name , receiver_first_name , receiver_last_name ,REPLACE(dbo.fnStripNonAscii(payment_note), '?', '') AS [payment_note] ,amount,bank,amount_recovered,recovery_date, call_eligibility
		
FROM Custom_Venmo_Import_NewBiz_File2 cbtinbf WITH (NOLOCK)
WHERE account_id NOT IN (SELECT account FROM master m WITH (NOLOCK) WHERE customer = '0001759')
	
END

GO
