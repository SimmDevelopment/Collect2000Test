SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_MT_CACS_Import_Truncate] 

AS
BEGIN

	SET NOCOUNT ON;

TRUNCATE TABLE Custom_MT_CACS_PrimaryContact_Import
TRUNCATE TABLE Custom_MT_CACS_SecondaryContact_Import
TRUNCATE TABLE Custom_MT_CACS_OtherContact_Import
TRUNCATE TABLE Custom_MT_CACS_Contact_Address
TRUNCATE TABLE Custom_MT_CACS_Contact_Email
TRUNCATE TABLE Custom_MT_CACS_Contact_Phone
TRUNCATE TABLE Custom_MT_CACS_Debt_Validation
TRUNCATE TABLE Custom_MT_CACS_LegalData
END
GO
