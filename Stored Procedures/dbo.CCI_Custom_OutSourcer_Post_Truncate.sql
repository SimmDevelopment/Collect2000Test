SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CCI_Custom_OutSourcer_Post_Truncate] 

AS
BEGIN

	SET NOCOUNT ON;

TRUNCATE TABLE CCI_Custom_OutSourcer_Post_AccountHolder
TRUNCATE TABLE CCI_Custom_OutSourcer_Post_Address
TRUNCATE TABLE CCI_Custom_OutSourcer_Post_Emails
TRUNCATE TABLE CCI_Custom_OutSourcer_Post_Extended
TRUNCATE TABLE CCI_Custom_OutSourcer_Post_Phones

END
GO
