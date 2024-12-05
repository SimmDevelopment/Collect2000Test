SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*

EXEC [Custom_Report_SIMM_Activity_Report_All] 

*/

-- =============================================================================
-- Author:		Scott Gorman
-- ALTER  date: 12/15/2006
-- Description:	Client Activity Report by current month, current year, and total
-- =============================================================================
CREATE 		PROCEDURE [dbo].[Custom_Report_SIMM_Activity_Report_All]
--@customer as varchar(8000)
--      @month VARCHAR(2), 
--      @year VARCHAR(4)
AS
BEGIN

	--get date values
	DECLARE @currentDate datetime
	DECLARE @month VARCHAR(2)
	DECLARE @year VARCHAR(4)
	set @currentDate = getdate()
	select @month = month(@currentDate),@year = year(@currentDate)
	if @month in (1,2,3,4,5,6,7,8,9) set @month = '0' + @month
	DECLARE @startdate datetime
	DECLARE @enddate datetime
	set @startdate = @year + @month + '01'
	if @month = 2 set @enddate = @year + @month + '28'
	if @month in (1,3,5,7,8,10,12) set @enddate = @year + @month + '31'
	if @month in (4,6,9,11) set @enddate = @year + @month + '30'

	--temp table
	DECLARE @activity_report_month TABLE (
		customer VARCHAR(7) NOT NULL,
		--name varchar(50) NULL,
		number_assign_month INTEGER NULL,
		amount_assign_month MONEY NULL
	);
	DECLARE @activity_report_month_payment TABLE (
		customer VARCHAR(7) NOT NULL,
		number_collected_month int NULL,
		amount_collected_month MONEY NULL,
		agency_earned MONEY NULL
	);
	DECLARE @activity_report_year TABLE (
		customer VARCHAR(7) NOT NULL,
		number_assign_year INTEGER NULL,
		amount_assign_year MONEY NULL
	);
	DECLARE @activity_report_year_payment TABLE (
		customer VARCHAR(7) NOT NULL,
		amount_collected_year MONEY NULL
		--rec_percentage_year decimal NULL,
	);
	DECLARE @activity_report_total TABLE (
		customer VARCHAR(7) NOT NULL,
		number_assign_total INTEGER NULL,
		amount_assign_total MONEY NULL,
		last_assign_total datetime NULL
	);
	DECLARE @activity_report_total_payment TABLE (
		customer VARCHAR(7) NOT NULL,
		amount_collected_total MONEY NULL
		--rec_percentage_total decimal NULL,
	);


	INSERT INTO @activity_report_month (customer,number_assign_month,amount_assign_month)
	SELECT m.customer,count(*),sum(m.original)
	FROM master m WITH(NOLOCK) 
	WHERE m.received between @startdate and @enddate
	group by m.customer

	INSERT INTO @activity_report_month_payment (customer,number_collected_month,amount_collected_month,agency_earned)
	select m.customer,COUNT(*),sum(p.totalpaid),sum(isnull(dbo.custom_calculatepaymenttotalfee(p.uid),0))
	FROM master m WITH(NOLOCK)
	JOIN payhistory p WITH(NOLOCK) ON p.number = m.number
	WHERE p.datepaid between @startdate and @enddate
	group by m.customer
--select top 5 agency_earned, * from payhistory
--select * from @activity_report_month_payment

	INSERT INTO @activity_report_year (customer,number_assign_year,amount_assign_year)
	SELECT m.customer,count(*),sum(m.original)
	FROM master m WITH(NOLOCK) 
	WHERE m.received between (@year+'0101') and @year+'1231'
	group by m.customer

	INSERT INTO @activity_report_year_payment (customer,amount_collected_year)
	select m.customer,sum(p.totalpaid)
	FROM master m WITH(NOLOCK)
	JOIN payhistory p WITH(NOLOCK) ON p.number = m.number
	WHERE p.datepaid between ('2007'+'0101') and '2007'+'1231'
	group by m.customer

	INSERT INTO @activity_report_total (customer,number_assign_total,amount_assign_total,last_assign_total)
	SELECT m.customer,count(*),sum(m.original),MAX(m.received)
	FROM master m WITH(NOLOCK) 
	group by m.customer

	INSERT INTO @activity_report_total_payment (customer,amount_collected_total)
	select m.customer,sum(p.totalpaid)
	FROM master m WITH(NOLOCK)
	JOIN payhistory p WITH(NOLOCK) ON p.number = m.number
	group by m.customer

	DECLARE @activity_report TABLE (
		customer VARCHAR(7) NOT NULL,
		customername VARCHAR(50) NOT NULL,
		[Month_Number_Assign]int NULL,
		[Month_Amount_Assign] money NULL,
		[Month_Number_Collected]int NULL,
		[Month_Amount_Collected] money NULL,
		[Month_Agency_Earned] money NULL,
		[Month_Unit_Yield] VARCHAR(10) NULL,
		[Year_Number_Assign]int NULL,
		[Year_Amount_Assign] money NULL,
		[Year_Amount_Collected] money NULL,
		[Year_REC%] VARCHAR(10) NULL,
		[Year_Unit_Yield] VARCHAR(10) NULL,
		[Total_Number_Assign]int NULL,
		[Total_Amount_Assign] money NULL,
		[Total_Amount_Collected] money NULL,
		[Total_REC%] VARCHAR(10) NULL,
		[Total_Unit_Yield] VARCHAR(10) NULL,
		[Total_Last_Assign] datetime NULL
);
INSERT INTO @activity_report (customer,customername,
[Month_Number_Assign],
[Month_Amount_Assign],
[Month_Number_Collected],
[Month_Amount_Collected],
[Month_Agency_Earned],
[Month_Unit_Yield],
[Year_Number_Assign],
[Year_Amount_Assign],
[Year_Amount_Collected],
[Year_REC%],
[Year_Unit_Yield],
[Total_Number_Assign],
[Total_Amount_Assign],
[Total_Amount_Collected],
[Total_REC%],
[Total_Unit_Yield],
[Total_Last_Assign])

	SELECT	c.customer as Client#,
			c.name as [Name],
			ISNULL(arm.number_assign_month,0)	as [Number Assign],
			cast(ISNULL(arm.amount_assign_month,0) as money) as [Amount Assign],
			ISNULL(armp.number_collected_month,0) as [Number Collected],
			armp.amount_collected_month  as [Amount Collected],--cast(ISNULL(armp.amount_collected_month,0) as money) as [Amount Collected],
			cast(ISNULL(armp.agency_earned,0) as money) as [Agency Earned],
			CASE WHEN arm.number_assign_month is null THEN '' ELSE cast((ISNULL((ISNULL(armp.amount_collected_month,0.00)/ISNULL(arm.number_assign_month,0)),0)) as varchar(10)) end as  [Unit Yield],
			ISNULL(ary.number_assign_year,0) as [Number Assign],
			cast(ISNULL(ary.amount_assign_year,0) as money) as [Amount Assign],
			cast((ISNULL(aryp.amount_collected_year,0)) as money) as [Amount Collected],
			ISNULL(CASE WHEN ary.amount_assign_year = 0 THEN '0.0'
				 ELSE cast((((aryp.amount_collected_year/ary.amount_assign_year) * 100)) as varchar(10))
			END,0.0) as [REC%],
			CASE WHEN ary.number_assign_year is null THEN '' ELSE cast((ISNULL((ISNULL(aryp.amount_collected_year,0.00)/ISNULL(ary.number_assign_year,0)),0)) as varchar(10)) end as [Unit Yield],
			ISNULL(art.number_assign_total,0) as [Number Assign],
			cast((ISNULL(art.amount_assign_total,0)) as money) as [Amount Assign],
			cast((ISNULL(artp.amount_collected_total,0)) as money) as [Amount Collected],
			ISNULL(CASE WHEN art.number_assign_total = 0 THEN '0.0'
				 ELSE cast((round(((artp.amount_collected_total/art.amount_assign_total) * 100),1)) as varchar(10))
			END,0.0) as [REC%],
			CASE WHEN art.number_assign_total is null THEN '' ELSE cast((ISNULL((ISNULL(artp.amount_collected_total,0.00)/ISNULL(art.number_assign_total,0)),0)) as varchar(10)) end as [Unit Yield],
			art.last_assign_total as [Last Assign]
	FROM customer c WITH(NOLOCK) 
	LEFT OUTER JOIN @activity_report_month arm on arm.customer = c.customer
	LEFT OUTER JOIN @activity_report_month_payment armp on armp.customer = c.customer
	LEFT OUTER JOIN @activity_report_year ary on ary.customer = c.customer
	LEFT OUTER JOIN @activity_report_year_payment aryp on aryp.customer = c.customer
	LEFT OUTER JOIN @activity_report_total art on art.customer = c.customer
	LEFT OUTER JOIN @activity_report_total_payment artp on artp.customer = c.customer

INSERT INTO @activity_report (customer,customername,[Month_Number_Assign],[Month_Amount_Assign],[Month_Number_Collected],
		[Month_Amount_Collected],[Month_Agency_Earned],[Month_Unit_Yield],[Year_Number_Assign],[Year_Amount_Assign],[Year_Amount_Collected],[Year_REC%],[Year_Unit_Yield],[Total_Number_Assign],[Total_Amount_Assign],[Total_Amount_Collected],[Total_REC%],[Total_Unit_Yield],[Total_Last_Assign])
SELECT '','TOTALS',sum([Month_Number_Assign]),sum([Month_Amount_Assign]),sum([Month_Number_Collected]),
		sum([Month_Amount_Collected]),sum([Month_Agency_Earned]),'',sum([Year_Number_Assign]),sum([Year_Amount_Assign]),sum([Year_Amount_Collected]),
		'','',sum([Total_Number_Assign]),sum([Total_Amount_Assign]),sum([Total_Amount_Collected]),'','',null
FROM @activity_report

select	customer as [Client#],
		customername as [Name],
		[Month_Number_Assign] as [Number Assign],
		[Month_Amount_Assign] as [Amount Assign],
		[Month_Number_Collected] as [Number Collected],
		[Month_Amount_Collected] as [Amount Collected],
		[Month_Agency_Earned] as [Agency Earned],
		[Month_Unit_Yield] as [Unit Yeild],
		[Year_Number_Assign] as [Number Assign],
		[Year_Amount_Assign] as [Amount Assign],
		[Year_Amount_Collected] as [Number Collected],
		[Year_REC%] as [REC%],
		[Year_Unit_Yield] as [Unit Yeild],
		[Total_Number_Assign] as [Number Assign],
		[Total_Amount_Assign] as [Amount Assign],
		[Total_Amount_Collected] as [Number Collected],
		[Total_REC%] as [REC%],
		[Total_Unit_Yield] as [Unit Yeild],
		[Total_Last_Assign] as [Last Assigned]
FROM @activity_report 

END




GO
