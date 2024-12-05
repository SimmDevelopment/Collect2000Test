SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Reset_Temp_Tables]

	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_USBank_Temp_Address
	TRUNCATE TABLE Custom_USBank_Temp_BaseContact
	TRUNCATE TABLE Custom_USBank_Temp_ContactAcct
	TRUNCATE TABLE Custom_USBank_Temp_Emails
	TRUNCATE TABLE Custom_USBank_Temp_Phones
	TRUNCATE TABLE Custom_USBank_Temp_Placement
	TRUNCATE TABLE Custom_USBank_Temp_TimeToCall
	
END
GO
