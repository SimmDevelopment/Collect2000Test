SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCO_NCT_BKY]
	-- Add the parameters for the stored procedure here
	@startDate datetime,
	@endDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.SSN, b.DateFiled AS [Date Filed], b.Chapter, b.CaseNumber AS [Case Number], b.CourtDistrict AS [Court District], b.Status
FROM master m WITH (NOLOCK) INNER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID
WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 174) AND m.status IN ('bky', 'b07', 'b11', 'b13')
AND dbo.date(closed) BETWEEN @startDate AND @endDate

END
GO
