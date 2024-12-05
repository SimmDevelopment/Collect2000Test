SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LINK_BD_Recall_Return] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	    
SELECT m.id1 AS [AccountID], 'SAI' AS [VendorID], CASE m.status WHEN 'DIS' THEN 'Y' WHEN 'DSP' THEN 'Y'  WHEN 'PPP' THEN 'Y' WHEN 'DIP' THEN 'Y' WHEN 'FRD' THEN 'Y'
WHEN 'ATY' THEN 'Y' WHEN 'RSK' THEN 'Y' WHEN 'POA' THEN 'Y' WHEN 'OOS' THEN 'Y' 
WHEN 'MIL' THEN 'Y' WHEN 'CAD' THEN 'Y' WHEN 'CND' THEN 'Y' WHEN 'DEC' THEN 'Y' WHEN 'B07' THEN 'Y' 
WHEN 'B11' THEN 'Y' WHEN 'B13' THEN 'Y' WHEN 'BKO' THEN 'Y' WHEN 'BKY' THEN 'Y' WHEN 'CCR' THEN 'Y' WHEN 'PIF' THEN 'Y'
WHEN 'RCL' THEN 'Y' WHEN 'SIF' THEN 'Y' WHEN 'OLD' THEN 'Y' ELSE '' END AS [Return_To_LRR],
--CASE s.statustype WHEN '0 - ACTIVE' THEN 'N' WHEN '1 - CLOSED' THEN 'Y' end AS [Return_To_LRR], 
CASE m.status WHEN 'DIS' THEN 'ZZNTD' WHEN 'PPP' THEN 'ZZPDP' WHEN 'DIP' THEN 'ZZINC' WHEN 'FRD' THEN 'ZZFRD'
WHEN 'ATY' THEN 'ZZATTY' WHEN 'DSP' THEN 'ZZDISP' WHEN 'RSK' THEN 'ZZLIT' WHEN 'POA' THEN 'ZZPOA' WHEN 'OOS' THEN 'ZZSOL' 
WHEN 'MIL' THEN 'ZZMIL' WHEN 'CAD' THEN 'ZZCND' WHEN 'CND' THEN 'ZZCND' WHEN 'DEC' THEN 'FSDECEASED' WHEN 'B07' THEN 'FSBANKRUPT' 
WHEN 'B11' THEN 'FSBANKRUPT' WHEN 'B13' THEN 'FSBANKRUPT' WHEN 'BKO' THEN 'FSBANKRUPT' WHEN 'BKY' THEN 'FSBANKRUPT' WHEN 'CCR' THEN 'FSRETURN'
WHEN 'RCL' THEN 'ZZAUTO' WHEN 'SIF' THEN 'ARSIF' WHEN 'PIF' THEN 'ZZPIF' WHEN 'OLD' THEN 'ZZVSOL' ELSE '' END AS [Return_Code], m.account AS [ClientAccountID]
FROM master m WITH (NOLOCK) INNER JOIN status s WITH (NOLOCK) ON m.status = s.code
INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE customer = '0003115'
AND sh.DateChanged BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
--AND status IN ('DIS', 'PPP', 'DIP', 'FRD', 'ATY', 'DSP', 'RSK', 'POA', 'OOS', 'MIL', 'CAD', 'CND' , 'DEC', 'B07', 'B11', 'B13' , 'BKO' , 'BKY', 'CCR', 'RCL', 'SIF', 'PIF', 'OLD')
--AND closed IS NOT null
AND returned = dbo.date(GETDATE())
--AND status NOT IN ('RCL', 'OOS')
ORDER BY m.received

END

GO
