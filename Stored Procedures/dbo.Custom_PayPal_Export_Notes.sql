SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
-- BGM 6/20/2019 - added temp table to pull specific accounts and removed n.created between @startDate and @EndDate to pull all notes
-- =============================================
CREATE PROCEDURE [dbo].[Custom_PayPal_Export_Notes]
	-- Add the parameters for the stored procedure here
--	@startDate datetime,
--@EndDate datetime,
@customer varchar(5000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Declare @startDate DATETIME
	--Declare @EndDate DATETIME
	--Declare @customer varchar(20)
	--SET @startDate = '20190325'
	--SET @EndDate = '20190325'
	--SET @customer = '0001256'
	
    -- Insert statements for procedure here
--	SET @startDate = dbo.F_START_OF_DAY(@startDate)
--SET @EndDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1,  @EndDate)))

DECLARE @startNumber INT
DECLARE @endNumber INT

SET @startNumber = 10800001
SET @endNumber =   11050000
--SET @startNumber = 10750001
--SET @endNumber =   11000000

SELECT 
			n.UID,
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 '95' as TransCode,        	 
			'01    ' as Seq,  
			isnull(substring(replace(replace(replace(convert(varchar(40),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 40), '') as Comment,
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
		where convert(varchar(100), n.comment) <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 2
SELECT n.UID,
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 '95' as TransCode,        	 
			'02    ' as Seq,  
			isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), ''),
		'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
		FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
		where isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber


UNION

--Get first 40 characters Line 3
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			
				'95' as TransCode,		
				         	 
			'03    ' as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(100),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 80, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 4
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'04    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 5
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,	
				         	 
			'05    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 6
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'06    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 7
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'07    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber
UNION

----Get first 40 characters Line 8
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'08    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber
UNION

----Get first 40 characters Line 9
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'09    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

----Get first 40 characters Line 10
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'10    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION


--Get first 40 characters Line 11
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				





								
				'95' as TransCode,				
				         	 
			'11    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 400, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 400, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 12
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,				
				         	 
			'12    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 440, 40), ''),
		'I' as Flag,
		'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 440, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 13
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'13    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 480, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 480, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 14
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'14    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 520, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 520, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 15
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,	
				         	 
			'15    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 560, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 560, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 16
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'16    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 600, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 600, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 17
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'17    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 640, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 640, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 18
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'18    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 680, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 680, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 19
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'19    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 720, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 720, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 20
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'20    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 760, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 760, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 21
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,				
				         	 
			'21    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 800, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 800, 40), '') <> '' and
	     m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 22
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,				
				         	 
			'22    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 840, 40), ''),
		'I' as Flag,
		'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 840, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 23
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'23    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 880, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 880, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 24
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'24    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 920, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 920, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 25
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,	
				         	 
			'25    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 960, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 960, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 26
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'26    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1000, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1000, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 27
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'27    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1040, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1040, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 28
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'28    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1080, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1080, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 29
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'29    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1120, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1120, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 30
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'30    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1160, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1160, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

--UNION

----Get first 40 characters Line 31
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,				
				         	 
			'31    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1200, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1200, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 32
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,				
				         	 
			'32    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1240, 40), ''),
		'I' as Flag,
		'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1240, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 33
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'33    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1280, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1280, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 34
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'34    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1320, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1320, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 35
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,	
				         	 
			'35    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1360, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1360, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 36
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,		
				         	 
			'36    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1400, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 140, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 37
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'37    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1440, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1440, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 38
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'38    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1480, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1480, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 39
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'39    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1520, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1520, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber

UNION

--Get first 40 characters Line 40
SELECT n.UID,
			
			REPLACE(CONVERT(char, n.created, 111), '/', '') as TransDate,
			LEFT(REPLACE(CONVERT(CHAR, n.created, 108), ':', ''), 4)as TransTime,
			m.account,
			 				
				'95' as TransCode,
				         	 
			'40    'as Seq,
			isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1560, 40), ''),
			'I' as Flag,
	'    ' AS RecovererCode,
	'EODMROPP' AS SystemID,
	'       ' as ProdCode
	FROM notes n with (Nolock) inner join Master m WITH(NOLOCK) on n.number = m.number INNER JOIN ztemppaypalsyncnotes z WITH (NOLOCK) ON m.account = z.account
	INNER JOIN customer c WITH(NOLOCK)
	on c.customer = m.customer
	where isnull(substring(replace(replace(replace(convert(varchar(2000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1560, 40), '') <> '' and
	      m.Customer in (select string from dbo.CustomStringToSet(@customer,'|')) and [action] not in ('DESK','LINK','SC')
	       AND user0 NOT IN ('EXG','PDT','Exchange','WORKFLOW','EXCH_SP')
	      and action + result + user0 <> '++++++++++DialConnec'
	      and ChargeOffDate >= '20180702' AND m.number BETWEEN @startNumber AND @endNumber


END
GO
