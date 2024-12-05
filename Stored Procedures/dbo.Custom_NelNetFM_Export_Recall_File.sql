SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 09/19/2024
-- Description:	Creates a Recall file that will close out accounts that are not in the daily file.
-- =============================================

CREATE PROCEDURE [dbo].[Custom_NelNetFM_Export_Recall_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account
FROM master m WITH (NOLOCK)
WHERE customer IN ('0003114')
AND account NOT IN (SELECT cnnfmf.AccountNumber FROM Custom_NelNet_FM_Main_File cnnfmf WITH (NOLOCK))
AND closed IS NULL


END
GO
