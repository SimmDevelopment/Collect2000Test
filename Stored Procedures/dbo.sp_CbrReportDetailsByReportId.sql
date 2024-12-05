SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_CbrReportDetailsByReportId*/
CREATE     PROCEDURE [dbo].[sp_CbrReportDetailsByReportId]
	@ReportId int
AS 

	SELECT rd.*, m.Name As AccountName, r.* FROM CbrReportDetail rd with(nolock)
	INNER JOIN CbrReport r with(nolock) ON rd.ReportId = r.Id
	INNER JOIN master m with(nolock) ON m.number = rd.AccountId
	WHERE rd.ReportId = @ReportId
	ORDER BY rd.AccountId ASC
GO
