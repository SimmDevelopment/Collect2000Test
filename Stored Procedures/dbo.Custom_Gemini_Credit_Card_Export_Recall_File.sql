SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:  08/05/2020 BGM - Changed query to look in the main inbound table instead of having to import data into a secondary table in order to save time.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Gemini_Credit_Card_Export_Recall_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
	SELECT account 
	FROM master m WITH (NOLOCK) 
	WHERE account NOT IN (SELECT AccountNumber FROM Custom_Gemini_Credit_Card_Import_Active_Accounts cgcciaa WITH (NOLOCK) 
) and customer IN ('0002891')AND closed IS NULL


END



GO
