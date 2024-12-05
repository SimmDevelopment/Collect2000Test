SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20070101'
set @endDate='20070131'
set @customer='0000833|'
exec Custom_Simms_JCAP_Closure @startDate=@startDate,@endDate=@endDate,@customer=@customer

*/
CREATE PROCEDURE [dbo].[Custom_Simms_JCAP_RT]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN
	--Header
	SELECT getdate() AS [Date]
	--Recall Record
	SELECT DISTINCT
		m.id2		 AS [BFrame],
		'5555' AS [RemoteID],
		m.received   AS [PlacedDate],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'PORTFOLIO')		 AS [Portfolio],
		'RT'		 AS [RecordType],
		m.account	 AS [Account],
		getdate()	 AS [Date],
		m.name		 AS [Name],
		m.current0 	 AS [Balance],
		ABS(m.paid)  	AS [TotalPaid],
		m.clialp	 AS [LastPaid],
		m.closed	 AS [StatusDate],
		
		CASE m.status
		WHEN 'ATY' THEN 'ATTY'
		WHEN 'B07' THEN 'BKRPND'
		WHEN 'B11' THEN 'BKRPND'
		WHEN 'B13' THEN 'BKRPND'
		WHEN 'BKY' THEN 'BKRPND'
		WHEN 'CND' THEN 'CCOMM'
		WHEN 'DSP' THEN 'DISP'
		WHEN 'VDS' THEN 'PNDDIS'
		WHEN 'RCL' THEN 'RCCONF'
		WHEN 'PIF' THEN 'PIF'
		WHEN 'SIF' THEN 'SIF'
		WHEN 'MIL' THEN 'SSRA'
		WHEN 'RSK' THEN 'LITIGA'
		ELSE 'NA'
		END	 AS [Status],
		CASE WHEN status = 'SIF' THEN CONVERT(VARCHAR(8), lastpaid, 112) ELSE '' END AS [FinalPayment],
		CASE WHEN status = 'SIF' THEN ABS(m.paid) ELSE 0 END AS [TotalSIF],
		CASE WHEN status = 'SIF' THEN ABS(m.paid) ELSE 0 END AS [TotalForgiven]

FROM master m with (nolock)
WHERE m.closed between @startDate AND @endDate AND 
m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND m.returned is null AND m.status IN ('ATY', 'B07', 'B11', 'B13', 'BKY', 'CND', 'DSP', 'VDS', 'RCL', 'PIF', 'SIF', 'MIL', 'RSK')

END


GO
