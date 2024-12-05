SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Export_Replaced_Accounts]
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SEQID_LOAN
	FROM Custom_CollegeAve_Main_File ccamf WITH (NOLOCK)
	WHERE SEQID_LOAN IN (SELECT account FROM master m2 WITH (NOLOCK) WHERE customer IN ('0001439','0001768') AND closed IS NOT null)

END
GO
