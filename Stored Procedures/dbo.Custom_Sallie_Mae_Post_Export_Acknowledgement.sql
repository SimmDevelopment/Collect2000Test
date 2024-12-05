SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 01/18/2022
-- Description:	Export Acknowledgement File for Sallie Mae CO Placements by Date
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Export_Acknowledgement]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'N' AS ISRETURN, '' AS RETURNREASON, '' AS ZZFSACPHOBJREASON, 'ACT' AS ARACVENSTATID, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE m.number = number AND Title = 'acc.0.afacintrate') AS AFACINTRATE,
(SELECT TOP 1 FORMAT(CAST(TheData AS DATE), 'MMddyyyy') from MiscExtra WITH (NOLOCK) WHERE Title = 'acc.0.afacinthrudt' AND Number = m.number) AS AFACINTHRUDR, '' AS ARACLPYAMT, '' AS ARACLPYDTE, 'N' AS ARACDISPUTE, '' AS ARACDISPRSNID,
'' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.Seq = 0
WHERE customer = 1120 AND CAST(m.received AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

END
GO
