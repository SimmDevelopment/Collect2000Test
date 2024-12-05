SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_C360_RMS_Reset_Temp_Maintenance_Tables]

	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_SunTrust_CACS_C360_RMS_Account_Maintenance
	TRUNCATE TABLE Custom_SunTrust_CACS_Contact_Account_Data_Maintenance
	TRUNCATE TABLE Custom_SunTrust_CACS_Contact_Address_Maintenance
	TRUNCATE TABLE Custom_SunTrust_CACS_Contact_Base_Data_Maintenance
	TRUNCATE TABLE Custom_SunTrust_CACS_Contact_Email_Maintenance
	TRUNCATE TABLE Custom_SunTrust_CACS_Contact_Phone_CallTime_Maintenance
	TRUNCATE TABLE Custom_SunTrust_CACS_Contact_Phone_Maintenance
	TRUNCATE TABLE Custom_Suntrust_CACS_Contact_Debt_Validation
	
END
GO
