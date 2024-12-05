SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Target_Report_SIF_PIF]
@startDate datetime,
@endDate datetime

AS

SELECT account [Account Number], name [Guest Name], closed [SIF Date], original [Beg Bal], ABS(paid) [SIF Amt], current0 [Remain Bal]
FROM Master  m WITH (NOLOCK)
where m.account in (select account from customtargetsif with (nolock) where reported = 0)


update customtargetsif
set reported = 1
where reported = 0

SELECT account [Account Number], name [Guest Name], closed [PIF Date], original [Beg Bal], ABS(paid) [PIF Amt], current0 [Remain Bal]
FROM StatusHistory s WITH (NOLOCK)  join Master  m WITH (NOLOCK)
ON s.accountid = m.number
where (s.DateChanged between @startDate and @endDate) and  m.customer = '0000856' and  s.NewStatus = 'PIF'

/*
SELECT account [Account Number], name [Guest Name], closed [SIF Date], original [Beg Bal], ABS(paid) [SIF Amt], current0 [Remain Bal]
FROM master with (nolock)
WHERE customer = '0000856' and status = 'SIF' and closed BETWEEN @startDate AND @endDate

SELECT account [Account Number], name [Guest Name], closed [PIF Date], original [Beg Bal], ABS(paid) [PIF Amt], current0 [Remain Bal]
FROM master with (nolock)
WHERE customer = '0000856' and status = 'PIF' and closed BETWEEN @startDate AND @endDate
*/
GO
