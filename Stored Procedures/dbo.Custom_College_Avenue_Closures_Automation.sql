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
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Closures_Automation] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME,
	@customer VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--altered for automation
	declare @Automation_StartDate datetime;
	declare @Automation_EndDate datetime;

	declare @10date datetime;
	declare @12date datetime;

	select @10date = (select param1 from custom_automate_run where job_name = '(A) CA Export 10')
	select @12date = (select param2 from custom_automate_run where job_name = '(A) CA Export 12')

	select @Automation_StartDate = isnull(@10date,@12date)
	select @Automation_EndDate = isnull(@10date,@12date)

	--select @Automation_StartDate ,@Automation_EndDate

    -- Insert statements for procedure here
	SELECT account AS [Account #], s.Description AS [Reason Closed], m.Closed
FROM master m WITH (NOLOCK) INNER JOIN status s WITH (NOLOCK) ON m.status = s.code
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND closed BETWEEN CAST(@Automation_StartDate AS DATE) AND CAST(@Automation_EndDate AS DATE)
ORDER BY m.received

END
GO
