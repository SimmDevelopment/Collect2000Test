SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[sp_Custom_ShermanForecastExport_new]
@customer varchar(8000),
@fte varchar(30),
@maxnewbusiness varchar(30),
@newbusinessforecast varchar(30),
@oldbusinessforecast varchar(30)


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
	 @oldbiz as oldbusiness,
	 case 
		when @customer in ('0001029', '0000735', '0000789', '0000746', '0000790', 
						'0000815', '0000803', '0000816', '0000821', '0000734', '0000824', 
						'0000797', '0000802', '0000808', '0000782', '0000787', '0000807', 
						'0000812', '0000781') then 'Broken Recent Payer'
		when @customer in ('0001035', '0001009', '0001077', '0001075', '0000721', '0001068',
						'0000753', '0000714', '0000696') then 'Retail Primary'
		when @customer in ('0001078', '0001093', '0000996', '0000924', '0000921') then 'Bankcard Primary'
		when @customer in ('0001073', '0001022') then 'Bankcard Secondary'
		when @customer = '0001045' then 'Recent Payer'
		when @customer in ('0000925', '0000897', '0000909', '0000889', '0000908', '0000914') then 'Retail Secondary'
		when @customer in ('0000892') then 'Small Balance Primary'
		when @customer in ('0000810') then 'Closed'
		when @customer in ('0000929') then 'Consolidated Legal'
		when @customer in ('0001121') then 'Deceased Primary'
		else 'NA'
		end as placetype,
	case
		when @customer in ('0000924', '0000921', '0000735', '0000789', '0000746', '0000790', '0000815', 
						'0000803', '0000816', '0000821', '0000734', '0000824', '0000797', '0000802', '0000808',
						'0000782', '0000787', '0000807', '0000812', '0000781', '0000810', '0000721', '0001029', 
						'0000753', '0000714', '0000696', '0000892') then 'Standard'
		when @customer in ('0001009', '0001077') then 'Household 180'
		when @customer in ('0001078', '0001093', '0000996') then 'High Core'
		when @customer = '0001022' then 'Premium'
		when @customer in ('0001068', '0001035') then 'GE Flow'
		when @customer in ('0001073', '0000925', '0000897', '0000909', '0000889', '0000908', '0000914') then 'High Value'
		when @customer = '0001045' then 'Strategy 5'
		when @customer = '0000929' then 'Strategy'
		when @customer in ('0001075') then 'Household 180 Contender'
		when @customer in ('0001121') then 'Standard'
		else 'NA'
		end as specservtype,
	 @maxnewbusiness as maxnewbusiness,
	 @fte as fte
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
