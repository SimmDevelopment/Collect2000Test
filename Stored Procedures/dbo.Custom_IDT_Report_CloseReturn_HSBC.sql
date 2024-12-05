SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO





CREATE      PROCEDURE [dbo].[Custom_IDT_Report_CloseReturn_HSBC]
@startDate datetime,
@endDate datetime

AS

SELECT account as [CFG_ACCOUNT], 
	CASE m.status
		WHEN 'B07' THEN 'OVBK'
		WHEN 'B11' THEN 'OVBK'
		WHEN 'B13' THEN 'OVBK'
		WHEN 'BKY' THEN 'OVBK'
		WHEN 'DEC' THEN 'OVDC'
		WHEN 'AEX' THEN 'OVUN'
		WHEN 'DSP' THEN 'ODSP'
		WHEN 'RCL' THEN 'OVRC'
		WHEN 'CXL' THEN 'OVRC'
		WHEN 'CCR' THEN 'OVRC'
		WHEN 'FRD' THEN 'OVFA'
		WHEN 'CAD' THEN 'OCAC'
		WHEN 'SIF' THEN 'OSIF'
		WHEN 'PIF' THEN 'OPIF'
		WHEN 'DIP' THEN 'OINC'
		ELSE m.status
	END STATUS,
	b.chapter [BKT CHAPTER],
	b.CaseNumber [BKT CASE#],
	b.DateFiled [BKT FILE DATE],
	d.dod [DATE OF DEATH],
	NULL COMMENTS,
	case m.customer
		when '0000981' then m.id1
		when '0000982' then m.id1
		when '0000965' then m.id1
		else m.id2
		end  ORIGINALACCOUNT
FROM master m 
LEFT JOIN Deceased d ON m.number = d.AccountID 
LEFT JOIN Bankruptcy b ON m.number = b.AccountID
WHERE customer in (select customerid from fact with (nolock) where customgroupid = 96) AND m.status IN ('B07', 'B11', 'B13', 'BKY', 'CXL', 'DEC', 'AEX', 'DSP', 
	'RCL', 'FRD', 'CAD', 'SIF', 'PIF','CCR', 'DIP') AND m.closed BETWEEN @startDate AND @endDate
GO
