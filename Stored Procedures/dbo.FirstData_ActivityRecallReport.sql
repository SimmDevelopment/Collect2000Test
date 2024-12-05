SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[FirstData_ActivityRecallReport] 
@rundate datetime,
@filename varchar(500),
@begindate datetime,
@enddate datetime 
AS 
SET @enddate = CAST(CONVERT(varchar(10),@enddate,20) + ' 23:59:59.000' as datetime) 
TRUNCATE TABLE FirstData_AccountActivity

INSERT INTO FirstData_AccountActivity
(number,account,message,rundate,filename)
SELECT
m.number,
m.account,
'',
@rundate,
@filename 
FROM master m WITH (NOLOCK) 
INNER JOIN FirstDataDownloadRecalls fd
ON RTRIM(LTRIM(m.account)) = RTRIM(LTRIM(fd.account))
WHERE fd.rundate = @rundate and fd.filename = @filename and RTRIM(LTRIM(fd.account)) <> ''
				   
Update FirstData_AccountActivity 
SET message = message + 'Payments,' 
FROM payhistory ph WITH (NOLOCK) 
INNER JOIN FirstData_AccountActivity fd 
ON fd.number = ph.number 
WHERE ph.datepaid BETWEEN @begindate and @enddate 

Update FirstData_AccountActivity
SET message = message + 'PDCs,' 
FROM PDC p WITH (NOLOCK) 
INNER JOIN FirstData_AccountActivity fd 
ON fd.number = p.number 
WHERE p.deposit BETWEEN @begindate and @enddate 

Update FirstData_AccountActivity 
SET message = message + 'Credit Cards' 
FROM DebtorCreditCards d WITH (NOLOCK) 
INNER JOIN FirstData_AccountActivity fd 
ON d.number = fd.number 
WHERE d.depositdate BETWEEN @begindate and @enddate 

DELETE FROM FirstData_AccountActivity 
WHERE RTRIM(LTRIM(message)) = '' 

Update FirstData_AccountActivity 
Set Message = SUBSTRING(Message, 1, Len(Message) - 1)
WHERE SUBSTRING(message,LEN(message),1) = ','
GO
