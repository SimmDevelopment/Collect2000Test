SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*

declare @customer varchar(8000)
declare @recalldate datetime
declare @filename varchar(30)
--set @customer='0000882|0000480|0000555|0000571|0000583|0000774|0000880|0000881|0000882|'
--set @recalldate = '20070205'
set @filename = 'sp0203.dl'
exec Custom_Simms_CMS_recall 	@filename=@filename

*/
CREATE        PROCEDURE [dbo].[Custom_Simms_CMS_recall]
--	 @customer varchar(8000),
	 --@recalldate datetime
	@filename varchar(30)
AS
BEGIN

	DECLARE @activity_report TABLE (
		[clnt_ref] VARCHAR(30) NOT NULL,
		[dbtrno] INT NULL,
		[asigndt] DATETIME NULL,
		[aclntno] VARCHAR(30) NULL,
		[balance] MONEY NULL,
		[lstpydt] DATETIME NULL,
		[acctno] INT NULL,
		[payment] MONEY NULL,
		[not_found] VARCHAR(10) NULL,
		[reason] VARCHAR(5) NULL,
		[acstat] VARCHAR(3) NULL
	);

	INSERT INTO @activity_report ([clnt_ref],[dbtrno],[asigndt],[aclntno],[balance],[lstpydt],[acctno],[payment],[not_found],[reason],[acstat])
	SELECT 
		m.account AS 	[clnt_ref],
		d.debtorid AS 	[dbtrno],
		m.received AS 	[asigndt],	
		m.customer AS 	[aclntno],
		m.current0 AS 	[balance],
		m.lastpaid AS 	[lstpydt],
		m.number AS 	[acctno],
		(-1*paid) AS 	[payment],
		'' AS 		[not_found],
		f.recallcode AS	[reason],
		m.status AS 	[acstat]
	--select top 100 f.*
	FROM master m with(nolock) 
	join custom_recall_report f with(nolock) on f.account = m.account
	left outer join debtors d with(nolock) on d.number = m.number and d.seq=0
	where --m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) 	and 
	f.filename = @filename and 
	m.number in (select max(number) from master m2 with(nolock) where m2.account = m.account group by m2.account)



	INSERT INTO @activity_report ([clnt_ref],[dbtrno],[asigndt],[aclntno],[balance],[lstpydt],[acctno],[payment],[not_found],[reason],[acstat])	
	SELECT 'Total','',NULL,'',SUM([balance]),NULL,'',NULL,'','',''
	FROM @activity_report

	SELECT * FROM @activity_report

END









GO
