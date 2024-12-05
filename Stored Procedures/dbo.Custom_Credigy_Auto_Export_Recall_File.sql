SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Credigy_Auto_Export_Recall_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account
FROM master m WITH (NOLOCK)
WHERE customer = '0001041' AND account NOT IN 
(SELECT CUSTOMER_NUMBER 
FROM Custom_Credigy_Auto_Maint_Import ccami WITH (NOLOCK))
	
END
GO
