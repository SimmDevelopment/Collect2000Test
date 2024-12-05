SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Union_Bank_Export_Recall_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Account
FROM master m WITH (NOLOCK)
WHERE account NOT IN (
SELECT  CHDAccountNo
FROM Custom_UnionBank_Import_Dial_File c WITH (NOLOCK)
) AND customer = '0001103'

END
GO
