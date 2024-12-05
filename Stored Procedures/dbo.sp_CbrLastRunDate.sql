SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_CbrLastRunDate*/
CREATE     PROCEDURE [dbo].[sp_CbrLastRunDate]
	@ReportType int, @LastRunDate varchar(30) output
AS 
-- Name:		sp_CbrLastRunDate
-- Function:		This procedure will return the last run cbr report date 
--			as a string output parameter using report type input parameter.
-- Creation:		12/20/2002 jc
-- Change History:
	DECLARE @Value varchar(30)

	SELECT @Value = cast(max(CreatedDate) AS varchar(30))
	FROM CbrReport
	WHERE ReportType = @ReportType
		
	if @Value is null
		SELECT @LastRunDate = 'Never'
	else
		SELECT @LastRunDate = @Value
GO
