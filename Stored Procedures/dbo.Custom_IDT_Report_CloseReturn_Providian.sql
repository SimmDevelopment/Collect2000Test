SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO





CREATE      PROCEDURE [dbo].[Custom_IDT_Report_CloseReturn_Providian]
@startDate datetime,
@endDate datetime

AS

SELECT account, 
	CASE m.status
		WHEN 'B07' THEN 'OVBK'
		WHEN 'B11' THEN 'OVBK'
		WHEN 'B13' THEN 'OVBK'
		WHEN 'DEC' THEN 'OVDC'
		WHEN 'AEX' THEN 'OVUN'
		WHEN 'DSP' THEN 'ODSP'
		WHEN 'RCL' THEN 'OVRC'
		WHEN 'CCR' THEN 'OVRC'
		WHEN 'FRD' THEN 'OVFA'
		WHEN 'CAD' THEN 'OCAC'
		WHEN 'SIF' THEN 'OSIF'
		WHEN 'PIF' THEN 'OPIF'
		WHEN 'DIP' THEN 'OINC'
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
WHERE m.customer = '0000976' AND m.status IN ('B07', 'B11', 'B13', 'DEC', 'AEX', 'DSP', 
	'RCL', 'FRD', 'CAD', 'SIF', 'PIF','CCR', 'DIP') AND m.closed BETWEEN @startDate AND @endDate
GO
