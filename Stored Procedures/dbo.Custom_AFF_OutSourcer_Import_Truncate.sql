SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_OutSourcer_Import_Truncate] 

AS
BEGIN

	SET NOCOUNT ON;

TRUNCATE TABLE Custom_AFF_Outsourcer_AccountHolder_Import
TRUNCATE TABLE Custom_AFF_Outsourcer_Address_Import
TRUNCATE TABLE Custom_AFF_Outsourcer_Emails_Import
TRUNCATE TABLE Custom_AFF_Outsourcer_Extended_Import
TRUNCATE TABLE Custom_AFF_Outsourcer_Phones_Import

END
GO
