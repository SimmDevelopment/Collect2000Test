SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[sp_Custom_ShermanForecastExport]
@oldbusinessforecast varchar(30),
@newbusinessforecast varchar(30),
@customer varchar(8000)
AS
BEGIN
	DECLARE @datebegin as datetime
	DECLARE @dateend as datetime
	DECLARE @newbiz money
	DECLARE @oldbiz money
	DECLARE @rundate datetime
	DECLARE @sysmonth int
	DECLARE @sysyear int
	

	SET @rundate=getdate()
	SET @newbiz = CAST(@newbusinessforecast as money)
	SET @oldbiz = CAST(@oldbusinessforecast as money)
	
	-- Using the current month and current year from the control file build the begining date and set up the end date.
	SELECT @datebegin=CAST(CAST(CAST(currentyear as varchar(4)) + '-' +
				CASE 
					WHEN currentmonth < 10 THEN '0' + CAST(currentmonth as varchar(1))
					ELSE CAST(currentmonth as varchar(2)) 
					END + '-01' as varchar(10)) + ' 00:00:00.000' as datetime),
	@dateend=CAST(CONVERT(varchar(10),eomdate,20) + ' 23:59:59.000' as datetime),
	@sysmonth=currentmonth,@sysyear=currentyear
	FROM controlfile

	-- Find the sum of all payments and PDCs.
	SELECT
	SUBSTRING(CONVERT(varchar(10),@rundate,20),6,2) + '/' +
	SUBSTRING(CONVERT(varchar(10),@rundate,20),9,2) + '/' + 
	LEFT (CONVERT(varchar(10),@rundate,20),4) as rundate,
	REPLACE(RIGHT(CONVERT(varchar(30),@rundate,120),8),':','.') as runtime,
	(SELECT ISNULL(SUM(CASE 
				WHEN ph.batchtype IN('PU','PA','PC') THEN [dbo].[Custom_CalculatePaymentTotalPaid](ph.UID)
	            ELSE  [dbo].[Custom_CalculatePaymentTotalPaid](ph.UID)*-1
				END) ,0)
	FROM payhistory ph WITH(NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number=ph.number
	WHERE ph.systemmonth=@sysmonth AND ph.systemyear=@sysyear AND ph.BatchType NOT IN('DA','DAR')
	AND m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|'))) as totalpayments,
	(SELECT ISNULL(SUM(p.amount),0)
	 FROM PDC p WITH(NOLOCK)
	 INNER JOIN master m WITH(NOLOCK)
	 ON m.number=p.number
	 WHERE p.Active=1 AND p.Deposit BETWEEN @datebegin AND @dateend AND 
	 m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|'))) as pdcs,
	 @newbiz as newbusiness,
	 @oldbiz as oldbusiness
	 WHERE EXISTS(SELECT TOP 1 ph.number 
				FROM payhistory ph WITH (NOLOCK) 
				INNER JOIN master m WITH(NOLOCK)
				ON m.number=ph.number
				WHERE ph.systemmonth=@sysmonth AND ph.systemyear=@sysyear AND ph.BatchType NOT IN('DA','DAR')
				AND m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|'))) OR
			EXISTS (SELECT TOP 1 p.number
					FROM PDC p WITH(NOLOCK)
					INNER JOIN master m WITH(NOLOCK)
					ON m.number=p.number
					WHERE p.Active=1 AND p.Deposit BETWEEN @datebegin AND @dateend AND 
					m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|')))

END
GO
