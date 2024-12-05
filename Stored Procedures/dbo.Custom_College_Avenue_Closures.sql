SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Closures] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME,
	@customer VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account AS [Account #], s.Description AS [Reason Closed], m.Closed
FROM master m WITH (NOLOCK) INNER JOIN status s WITH (NOLOCK) ON m.status = s.code
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND closed BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
ORDER BY m.received

END
GO
