SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO





CREATE      PROCEDURE [dbo].[Custom_Target_Report_GetAcks]
@ackDate datetime
AS


SELECT Code, COUNT(*) RecCount, dbo.FormatIBMNumeric(SUM(MoneyVal), 20) TotalMoney, Date
FROM Custom_TargetAck 
WHERE Date = @ackDate AND Code <> 'ACKFIN'
GROUP BY Code, Date

UNION

SELECT 'ACKFIN' Code, COUNT(*) RecCount, 
	dbo.FormatIBMNumeric(SUM(CASE WHEN batchtype IN('PCR','DA') THEN -totalpaid ELSE totalpaid END), 20) TotalMoney, Date
FROM Custom_TargetAck INNER JOIN payhistory p
	ON '{' + CONVERT(varchar, [ID]) + '}' = checknbr AND p.customer = '0000856' INNER JOIN 
	master m ON p.number = m.number AND m.account = AccountNum
WHERE Date = @ackDate AND Code = 'ACKFIN' 
GROUP BY Code, Date

UNION

SELECT 'ACKREC', COUNT(*) RecCount, dbo.FormatIBMNumeric(0, 20) TotalMoney, @ackDate
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON n.number = m.number
WHERE DATEADD(day, 0, DATEDIFF(day, 0, created)) = @ackDate AND action='AR' AND 
	result = 'REC' AND customer = '0000856'


DECLARE @totalFin money
SELECT @totalFin = COALESCE(SUM(totalpaid), 0)
FROM Custom_TargetAck INNER JOIN master m WITH (NOLOCK)
	ON AccountNum = m.account INNER JOIN payhistory p WITH (NOLOCK)
	ON m.number = p.number AND p.DatePaid = TranDate AND p.customer = '0000856'
WHERE Date = @ackDate

SELECT dbo.FormatIBMNumeric(COALESCE(SUM(MoneyVal), 0) + @totalFin, 10) TotalMoney
FROM Custom_TargetAck
WHERE Date = @ackDate AND Code <> 'ACKFIN'




GO
