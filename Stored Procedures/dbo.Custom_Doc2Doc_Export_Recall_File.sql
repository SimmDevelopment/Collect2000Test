SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 05/05/2023
-- Description:	Export Recall File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Doc2Doc_Export_Recall_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account FROM master m WITH (NOLOCK) WHERE customer IN ('0003118')
AND account NOT IN (
SELECT ServicerAccountNumber
FROM Custom_Doc2Doc_Import_Active_Accounts cgiaa WITH (NOLOCK)
) AND closed IS NULL


END

GO
