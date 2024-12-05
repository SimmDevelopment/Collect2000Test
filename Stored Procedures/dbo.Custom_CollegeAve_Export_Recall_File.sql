SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 11/04/2022
-- Description:	Creates a Recall file that will close out accounts that are not in the daily file.
-- =============================================

CREATE PROCEDURE [dbo].[Custom_CollegeAve_Export_Recall_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001439','0001768')
AND account NOT IN (SELECT SEQID_LOAN FROM Custom_CollegeAve_Main_File ccamf WITH (NOLOCK))
AND closed IS NULL


END
GO
