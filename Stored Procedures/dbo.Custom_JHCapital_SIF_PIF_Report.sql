SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_SIF_PIF_Report] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1, m.status, CONVERT(VARCHAR(10), m.closed, 101) AS Closed
	FROM master m WITH (NOLOCK)
	WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID  in (186,280))
	AND closed BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND status IN ('sif', 'pif')
	and id2 not in ('AllGate','ARS-JMET')

END
GO
