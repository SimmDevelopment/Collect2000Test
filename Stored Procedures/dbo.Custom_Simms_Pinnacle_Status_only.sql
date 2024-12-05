SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*

DECLARE @startDate datetime
DECLARE	@endDate datetime
DECLARE	@customer varchar(8000)
SET @startDate = '20070101'
SET @endDate = '20070131'
SET @customer = '0000000|'
EXECUTE [Custom_Simms_Pinnacle_Status_only]    @startDate, @endDate, @customer

*/

CREATE   PROCEDURE [dbo].[Custom_Simms_Pinnacle_Status_only]
	@startdate datetime,
	@enddate datetime,
	@customer varchar(8000)
AS
BEGIN

	SELECT DISTINCT
		m.account AS [data_id],
		CASE	WHEN m.status in ('NEW') THEN '100'
				WHEN m.status in ('ACT') THEN '101'
				WHEN m.status in ('B07','B13','BKY') THEN '101'
				WHEN m.status in ('CND') THEN '101'
				WHEN m.status in ('DEC') THEN '101'
				WHEN m.status in ('FRD') THEN '101'
				WHEN m.status in ('PDC','PPA') THEN '101'
				WHEN m.status in ('SKP') THEN '101'
				WHEN m.status in ('DSP') THEN '102'
				WHEN m.status in ('LEG') THEN '199'
		END AS [status_code],
		d.firstname AS [pri_first],
		d.lastname AS [pri_last],
		m.current0 AS [bal_principal]
--select top 10 *
	FROM master m with (nolock)
	LEFT OUTER JOIN debtors d with(nolock) on d.number = m.number and d.seq = 0
	JOIN statushistory s with(nolock) on s.accountid = m.number
	WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	AND s.datechanged between @startdate and @enddate

end

GO
