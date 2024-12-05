SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Import_Truncate_Old] 

AS
BEGIN

	SET NOCOUNT ON;

TRUNCATE TABLE Custom_USBank_CACS_PrimaryContact_Import
TRUNCATE TABLE Custom_USBank_CACS_SecondaryContact_Import
TRUNCATE TABLE Custom_USBank_CACS_OtherContact_Import
TRUNCATE TABLE Custom_USBank_CACS_Contact_Address
TRUNCATE TABLE Custom_USBank_CACS_Contact_Email
TRUNCATE TABLE Custom_USBank_CACS_Contact_Phone

END
GO
