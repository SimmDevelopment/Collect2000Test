SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 09/20/2024
-- Description:	Create a file of existing accounts in the system that are being returned to work again.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NelnetFM_Export_Replaced_Accounts]
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT cnnfmf.AccountNumber
	FROM Custom_NelNet_FM_Main_File cnnfmf  WITH (NOLOCK)
	WHERE cnnfmf.AccountNumber IN (SELECT account FROM master m2 WITH (NOLOCK) WHERE customer IN ('0003114') AND closed IS NOT null)

END
GO
