SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/16/2022
-- Description:	Exports all record types for Suntrust BB&T Placement that are not already in the system
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Suntrust_BBT_Export_New_Placements] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--A Record
SELECT cs.Account_Number, cs.Record_Type, cs.Sequence_Number, cs.Title, cs.Customer_Type, cs.Name, cs.Account_Address_1, cs.Account_Address_2, cs.City, cs.County, cs.State, cs.Zip_Code, cs.Home_Phone_Number, 
cs.Work_Phone_Number, cs.Birthdate, cs.Employers_Name, cs.Employers_Address, cs.Loan_Type_Code, cs.Lending_Officer_Code, cs.User_Field, cs.DPS_ID_Attorney_Code, cs.Dealer_Code, cs.Chargeoff_Reason_Code, 
cs.Account_Status, cs.Interest_Rate, cs.Source_Code, cs.Receipt_Date, cs.Contract_Date, cs.Chargeoff_Date, cs.Last_Payment_Date, cs.Charge_off_Amount, cs.Associated_Costs, cs.Accrued_Interest, 
cs.Current_Balance, cs.Net_Principal, cs.Net_Associated_Costs, cs.Net_Interest, cs.Last_Comment_Line_1, cs.Last_Comment_Line_2, cs.Last_Comment_Line_3, cs.Last_Comment_Date, cs.Second_Name_1, cs.Second_Name_2, 
cs.Monthly_Income, cs.Other_Income, cs.Monthly_Payment, cs.Other_Obligations, cs.Own_Rent_Code, cs.Recovery_Score, cs.Next_Payment_Date, cs.Last_Interest_Date, cs.Last_Contact_Date, cs.Commission_Rate, 
cs.Home_Phone_Flag, cs.Work_Phone_Flag, cs.Address_Flag, cs.Customer_ID, cs.Filler, cs.MIOCode, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_ARec cs WITH (NOLOCK) 
WHERE cs.Account_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--C Record
SELECT cs.CAccount_Number, cs.Record_Type, cs.Sequence_Number, cs.Title, cs.Customer_Type, cs.Name, cs.Account_Address_1, cs.Account_Address_2, cs.City, cs.County, cs.State, cs.Zip_Code, cs.Home_Phone_Number, 
cs.Work_Phone_Number, cs.Birthdate, cs.Employers_Name, cs.Employers_Address, cs.Filler, cs.Customer_ID, cs.Filler2, cs.MIOCode, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_CRec cs WITH (NOLOCK) 
WHERE cs.CAccount_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--D Record
SELECT cs.DAccount_Number, cs.Record_Type, cs.Sequence_Number, cs.Last_Cash_Advance_Date, cs.Last_Purchase_Date, cs.No_of_Payment_in_Cycle1, cs.No_of_Payment_in_Cycle2, cs.No_of_Payment_in_Cycle3, 
cs.No_of_Payment_in_Cycle4, cs.No_of_Payment_in_Cycle5, cs.No_of_Payment_in_Cycle6, cs.No_of_Payment_in_Cycle7, cs.No_of_Payment_in_Cycle8, cs.No_of_Payment_in_Cycle9, cs.No_of_Payment_in_Cycle10, 
cs.No_of_Payment_in_Cycle11, cs.No_of_Payment_in_Cycle12, cs.Amount_of_Payments_in_Cycle1, cs.Amount_of_Payments_in_Cycle2, cs.Amount_of_Payments_in_Cycle3, cs.Amount_of_Payments_in_Cycle4, 
cs.Amount_of_Payments_in_Cycle5, cs.Amount_of_Payments_in_Cycle6, cs.Amount_of_Payments_in_Cycle7, cs.Amount_of_Payments_in_Cycle8, cs.Amount_of_Payments_in_Cycle9, cs.Amount_of_Payments_in_Cycle10, 
cs.Amount_of_Payments_in_Cycle11, cs.Amount_of_Payments_in_Cycle12, cs.Amount_of_Purchases_in_Cycle1, cs.Amount_of_Purchases_in_Cycle2, cs.Amount_of_Purchases_in_Cycle3, cs.Amount_of_Purchases_in_Cycle4, 
cs.Amount_of_Purchases_in_Cycle5, cs.Amount_of_Purchases_in_Cycle6, cs.Amount_of_Purchases_in_Cycle7, cs.Amount_of_Purchases_in_Cycle8, cs.Amount_of_Purchases_in_Cycle9, cs.Amount_of_Purchases_in_Cycle10, 
cs.Amount_of_Purchases_in_Cycle11, cs.Amount_of_Purchases_in_Cycle12, cs.Amount_of_Cash_Advance_in_Cycle1, cs.Amount_of_Cash_Advance_in_Cycle2, cs.Amount_of_Cash_Advance_in_Cycle3, 
cs.Amount_of_Cash_Advance_in_Cycle4, cs.Amount_of_Cash_Advance_in_Cycle5, cs.Amount_of_Cash_Advance_in_Cycle6, cs.Amount_of_Cash_Advance_in_Cycle7, cs.Amount_of_Cash_Advance_in_Cycle8, 
cs.Amount_of_Cash_Advance_in_Cycle9, cs.Amount_of_Cash_Advance_in_Cycle10, cs.Amount_of_Cash_Advance_in_Cycle11, cs.Amount_of_Cash_Advance_in_Cycle12, cs.Number_of_NSF_Checks, cs.Credit_Limit, 
cs.Number_of_Times_Past_Due_30_Days, cs.Number_of_Times_Past_Due_60_Days, cs.Number_of_Times_Past_Due_90_Days, cs.Number_of_Times_Past_Due_120_Days, cs.Number_of_Times_Past_Due_180_Days, cs.Amount_Past_Due_30_Days, 
cs.Amount_Past_Due_60_Days, cs.Amount_Past_Due_90_Days, cs.Amount_Past_Due_91_Days, cs.Amount_of_Payments_this_Cycle, cs.High_Credit_Amount, cs.Payoff_Amount, cs.Date_Matures, cs.Date_of_Regular_Payment, 
cs.Number_of_Months_Extended, cs.Late_Charges_Due, cs.Date_of_Last_Extension, cs.Filler, cs.Filler1, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_DRec cs WITH (NOLOCK) 
WHERE cs.DAccount_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--H Record
SELECT cs.HAccount_Number, cs.Record_Type, cs.Sequence_Number, FORMAT(CAST(cs.Transaction_Date AS DATE), 'yyyyMMdd') AS Transaction_Date, cs.Note_Line, cs.Transaction_Date1, cs.Note_Line1, cs.Transaction_Date2, cs.Note_Line2, cs.Transaction_Date3, cs.Note_Line3, 
cs.Transaction_Date4, cs.Note_Line4, cs.Transaction_Date5, cs.Note_Line5, cs.Transaction_Date6, cs.Note_Line6, cs.Transaction_Date7, cs.Note_Line7, cs.Transaction_Date8, cs.Note_Line8, cs.Transaction_Date9, 
cs.Note_Line9, cs.Transaction_Date10, cs.Note_Line10, cs.Transaction_Date11, cs.Note_Line11, cs.Transaction_Date12, cs.Note_Line12, cs.Filler, cs.MIOCode, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_HRec cs WITH (NOLOCK) 
WHERE cs.HAccount_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--K Record
SELECT cs.KAccount_Number, cs.Record_Type, cs.Sequence_Number, cs.Collateral_ID, cs.Collateral_Year, cs.Collateral_Make, cs.Date_of_Repossession, cs.Collateral_Sold_Date, cs.Collateral_Sale_Price, cs.Collateral_ID1, 
cs.Collateral_Year1, cs.Collateral_Make1, cs.Date_of_Repossession1, cs.Collateral_Sold_Date1, cs.Collateral_Sale_Price1, cs.Collateral_ID2, cs.Collateral_Year2, cs.Collateral_Make2, cs.Date_of_Repossession2, 
cs.Collateral_Sold_Date2, cs.Collateral_Sale_Price2, cs.Collateral_ID3, cs.Collateral_Year3, cs.Collateral_Make3, cs.Date_of_Repossession3, cs.Collateral_Sold_Date3, cs.Collateral_Sale_Price3, cs.Collateral_ID4, 
cs.Collateral_Year4, cs.Collateral_Make4, cs.Date_of_Repossession4, cs.Collateral_Sold_Date4, cs.Collateral_Sale_Price4, cs.Filler, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_KRec cs WITH (NOLOCK) 
WHERE cs.KAccount_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--M Record
SELECT cs.MAccount_Number, cs.Record_Type, cs.Sequence_Number, cs.Suit_Reason, cs.Suit_File_Date, cs.Suit_Case_Number, cs.Court_Name, cs.Judgement_Recorded_Date, cs.Judgement_Book, cs.Judgement_Page, 
cs.Judgement_Expiration_Date, cs.Creditor_Meeting_Location, cs.Creditor_Meeting_Date, cs.Creditor_Case_Number, cs.Filed_Date, cs.Bar_Date, cs.Dismiss_Date, cs.Discharge_Date, cs.Reaffirm_Date, 
cs.Stay_Lifted_Date, cs.Bankruptcy_Asset_Indicator, cs.Bankruptcy_User_Defined_Alpha2, cs.Bankruptcy_User_Defined_Alpha3, cs.Bankruptcy_User_Defined_Value1, cs.Bankruptcy_User_Defined_Value2, 
cs.Bankruptcy_User_Defined_Value3, cs.Bankruptcy_Filing_Date, cs.Bankruptcy_User_Defined_Date2, cs.Bankruptcy_User_Defined_Date3, cs.Legal_User_Amount1, cs.Legal_User_Amount2, cs.Legal_User_Amount3, 
cs.Legal_User_Amount4, cs.Legal_User_Amount5, cs.Legal_User_Amount6, cs.Legal_User_Amount7, cs.Legal_User_Amount8, cs.Bankruptcy_Attorney_Name, cs.Bankruptcy_Attorney_Address1, cs.Bankruptcy_Attorney_Address2, 
cs.Bankruptcy_Attorney_City, cs.Bankruptcy_Attorney_State, cs.Bankruptcy_Attorney_Zip, cs.Bankruptcy_Attorney_Phone, cs.Legal_User_Variable8, cs.Legal_User_Variable9, cs.Legal_User_Variable10, cs.Deceased_Date, 
cs.Legal_User_Date2, cs.Legal_User_Date3, cs.Legal_User_Date4, cs.Legal_User_Date5, cs.Legal_User_Date6, cs.Bankruptcy_Chapter, cs.Filler, cs.MIOCode, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_MRec cs WITH (NOLOCK) 
WHERE cs.MAccount_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--U Record
SELECT cs.UAccount_Number, cs.Record_Type, cs.Sequence_Number, cs.User_Defined_Alpha1, cs.User_Defined_Alpha2, cs.User_Defined_Alpha3, cs.User_Defined_Alpha4, cs.User_Defined_Alpha5, cs.User_Defined_Alpha6, 
cs.User_Defined_Alpha7, cs.User_Defined_Alpha8, cs.User_Defined_Numeric1, cs.User_Defined_Numeric2, cs.User_Defined_Numeric3, cs.User_Defined_Numeric4, cs.User_Defined_Numeric5, cs.User_Defined_Numeric6, 
cs.User_Defined_Numeric7, cs.User_Defined_Numeric8, cs.User_Defined_Date1, cs.User_Defined_Date2, cs.User_Defined_Date3, cs.User_Defined_Date4, cs.User_Defined_Date5, cs.User_Defined_Date6, cs.User_Defined_Date7, 
cs.User_Defined_Date8, cs.Filler, cs.Filler1, cs.Agency_Code, cs.Format_Code
FROM Custom_SunTrust_BBT_Temp_URec cs WITH (NOLOCK) 
WHERE cs.UAccount_Number NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

--X Record
SELECT cs.Xaccount, cs.RecordType, cs.SeqNumber, cs.Filler, cs.MSAOtherCell1, cs.[MSAOtherCell1-F], cs.MSAOtherCell2, cs.[MSAOtherCell2-F], cs.MSAMobileNumber, cs.MSACellFlag, cs.MSAEmailAddress, cs.CMKMobileNumber, 
cs.CMKMobileFlag, cs.CMKEmailAddress, cs.CurrInterest, cs.CurrFees, cs.CurrOthDebits, cs.CurrTotPayments, cs.CurrOthCredits, cs.Filler1, cs.MIOCode, cs.AgencyCode, cs.FormatCode
FROM Custom_SunTrust_BBT_Temp_XRec cs WITH (NOLOCK) 
WHERE cs.XAccount NOT IN (
SELECT M.account 
FROM master M WITH (NOLOCK) 
WHERE customer IN (1410, 1280, 2509,2510,2511,2512,2513)
) 

END
GO
