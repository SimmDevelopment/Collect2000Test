SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE      PROCEDURE [dbo].[Custom_IDT_Report_CloseReturn]
@startDate datetime,
@endDate datetime

AS

SELECT account, 
	CASE m.status
		WHEN 'B07' THEN 'BKT'
		WHEN 'B11' THEN 'BKT'
		WHEN 'B13' THEN 'BKT'
		WHEN 'DEC' THEN 'DEC'
		WHEN 'AEX' THEN 'UNC'
		WHEN 'DSP' THEN 'DISP'
		WHEN 'RCL' THEN 'RECALL'
		WHEN 'CCR' THEN 'RECALL'
		WHEN 'FRD' THEN 'FRAUD'
		WHEN 'CAD' THEN 'CC'
		ELSE m.status
	END reason,
	b.chapter [bkt chapter],
	b.CaseNumber [bkt case#],
	b.DateFiled [bkt file date],
	d.dod [date of death],
	NULL comments,
	m.id2 origacct
FROM master m 
LEFT JOIN Deceased d ON m.number = d.AccountID 
LEFT JOIN Bankruptcy b ON m.number = b.AccountID
WHERE m.customer = '0000915' AND m.status IN ('B07', 'B11', 'B13', 'DEC', 'AEX', 'DSP', 
	'RCL', 'FRD', 'CAD', 'SIF', 'PIF','CCR') AND m.closed BETWEEN @startDate AND @endDate

	





GO
