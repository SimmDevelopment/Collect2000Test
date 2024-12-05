SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCT_NCO_Tert_SIFPIF]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'SIM' AS Agency, account AS [Account Number], status AS [SIF/PIF], lastpaid AS [Payment Date], ABS(paid1 + paid2) / original AS [SIF Percentage]
FROM master WITH (NOLOCK)
WHERE customer IN ('0001283', '0001404') AND status IN ('sif', 'pif') AND dbo.date(closed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
