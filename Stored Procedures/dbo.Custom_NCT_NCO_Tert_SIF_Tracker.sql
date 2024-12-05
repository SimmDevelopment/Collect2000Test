SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCT_NCO_Tert_SIF_Tracker]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT 'SIMM' AS Agency, account AS [Account Number], name AS [Customer Name], CONVERT(VARCHAR(10), lastpaid, 101) AS [Last Pay Date], CONVERT(VARCHAR(5), (ABS(paid1 + paid2) / original) * 100) + '%' AS [SIF Percentage]
FROM master WITH (NOLOCK)
WHERE customer IN ('0001283', '0001404') AND status IN ('sif') AND dbo.date(closed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
