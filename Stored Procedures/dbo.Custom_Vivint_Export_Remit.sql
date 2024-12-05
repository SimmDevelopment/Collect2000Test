SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 11/13/2024
-- Description:	Export Remit by Invoice Numbers chosen
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Vivint_Export_Remit]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT m.account                      AS [Customer Account Number]
     , d.firstName + ' ' + d.lastName AS [Debtor Name]
	 , m.original AS [Original Balance]
	 , p.datepaid AS [Date Paid]
	 , CASE WHEN batchtype = 'PUR' THEN -(p.totalpaid) ELSE p.totalpaid END AS [Signed Applied Payment Amount]
	 , p.CollectorFee AS [Fee Amount]
	 , CASE WHEN batchtype = 'PUR' THEN -(p.totalpaid - p.CollectorFee) ELSE p.totalpaid - p.CollectorFee END AS [Signed Net Amount]
	 , m.current0 AS [Current Balance]
	 , CASE WHEN batchtype = 'PUR' THEN 'Paid Us Reversal' ELSE 'Paid Us' END AS [Payment Batch Type]
FROM dbo.payhistory p WITH (NOLOCK) INNER JOIN dbo.master m WITH (NOLOCK) ON p.number = m.number
    INNER JOIN dbo.Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.Seq = 0
WHERE m.customer = 3116 
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
AND p.batchtype IN ('PU', 'PUR');



END
GO
