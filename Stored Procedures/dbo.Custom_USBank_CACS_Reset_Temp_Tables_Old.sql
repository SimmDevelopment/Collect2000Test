SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 01/01/2017
-- Description:	Truncate US Bank Temp Tables
-- Changes: 02/05/2021 BGM Added truncating of the new temp recall table.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Reset_Temp_Tables_Old]

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
	TRUNCATE TABLE Custom_USBank_Temp_Recall
	
END
GO
