SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 12/16/2020
-- Description:	Export payment file for Union Bank Post Defualt
-- =============================================
CREATE PROCEDURE [dbo].[Custom_UnionBank_Post_Export_Payments]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SELECT m.account AS [Union Bank Account Number], 'SIMM' AS [Agency ID], m.received AS [Placement Date], p.datepaid AS [Payment Date], 
CASE WHEN batchtype LIKE '%r' THEN -(p.totalpaid) ELSE  p.totalpaid END  AS [Payment Amount], 
CASE WHEN batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE  p.CollectorFee END AS [Agency Fee]
, CASE WHEN batchtype LIKE '%r' THEN -(p.totalpaid - p.CollectorFee) ELSE  p.totalpaid - p.CollectorFee END  AS [Due Client], m.Name, m.current0 AS [Balance], 
CASE WHEN m.status = 'SIF' THEN 'SIF' WHEN m.STATUS = 'PIF' THEN 'PIF' WHEN p.batchtype LIKE '%r' THEN 'NSF' ELSE 'PPA' END AS [Description]
FROM dbo.payhistory p WITH (NOLOCK) INNER JOIN dbo.master m WITH (NOLOCK) ON p.number = m.number
WHERE m.customer = '0001118' --AND batchtype like 'pu%'
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))

END
GO
