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
CREATE PROCEDURE [dbo].[Custom_Gemini_Credit_Card_Export_Placement_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert into Custom_Gemini_Daily_Totals(LoadDate, TotalAccounts, TotalAmount)
	--select getdate(), count(*), isnull(sum(cast(current_balance as int)), 0)
	select getdate(), count(*), isnull(sum(cast(current_balance as money)), 0)
	 FROM Custom_Gemini_Credit_Card_Import_Active_Accounts cgiaa WITH (NOLOCK)
        Where AccountNumber NOT IN 
				(SELECT account
		FROM master WITH (NOLOCK)
		WHERE (closed IS NULL OR status IN ('pif', 'sif', 'cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd', 'dec', 'bky', 'b07', 'b11', 'b13'))
		AND (customer IN ('0002891')))
	
   
	SELECT CustomerName, AccountNumber,	Last_4_of_CC_Number, Primary_First_Name, Primary_Middle_Name, Primary_Last_Name, Credit_Bureau_Flag, Primary_Work_Phone,
	Primary_Home_Phone,	Primary_Cell_Phone,	Primary_Email, Account_Status, Current_Balance, Principal_Balance, Interest_Balance, Fee_Balance, Credit_Limit,	Total_Amount_Delinquent,
	MinimumPaymentDue, Last_Statement_Date,	Last_Statement_Balance,	Days_Delinquent, Last_Payment_Date,	Last_Payment_Amount, Behavior_Score, Primary_Address1, Primary_Address2,
	Primary_City, Primary_State, Primary_ZipCode, Primary_Employer_Name, Primary_Work_Address_1, Primary_Work_Address_2, Primary_Work_City,	Primary_Work_State,	Primary_Work_ZipCode,
	Six_Months_Active_Flag,	Last_Reage_Date, Primary_SSN, NSF_Check, Count#1_Cycle_Delinquent, Count#2_Cycle_Delinquent, Count#3_Cycle_Delinquent, Account_Creation_Date, Due_Date,
	Cycle_Day, Del_1_Cycle_Amount, Del_2_Cycle_Amount, Del_3_Cycle_Amount, Del_4_Cycle_Amount, Del_5_Cycle_Amount, Del_6_Cycle_Amount,	Del_7_Cycle_Amount,	Last_Statement_Date2,
	Last_Statement_Balance2, Fee_Balance2

        FROM Custom_Gemini_Credit_Card_Import_Active_Accounts cgiaa WITH (NOLOCK)
        Where AccountNumber NOT IN 
				(SELECT account
		FROM master WITH (NOLOCK)
		WHERE (closed IS NULL OR status IN ('pif', 'sif', 'cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd', 'dec', 'bky', 'b07', 'b11', 'b13'))
		AND (customer IN ('0002891')))

END
GO
