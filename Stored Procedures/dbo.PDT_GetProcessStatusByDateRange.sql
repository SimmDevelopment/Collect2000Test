SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PDT_GetProcessStatusByDateRange]
@startDate datetime,
@endDate datetime,
@service varchar(40)

AS

if(@service = 'Credit Card')
BEGIN
SELECT
d.Number,
m.customer as [Customer],
d.Name,
d.Amount,
DepositDate as [Deposit Date],
ProcessStatus as [Status],
PrintedDate as [Printed Date],
ID as [ID]
FROM debtorcreditcards d WITH (NOLOCK)
	JOIN master m WITH (NOLOCK) ON m.number = d.number
WHERE
	depositdate >= @startDate and depositdate <= @enddate
END

else
BEGIN
SELECT
p.Number,
m.customer as [Customer],
m.Name,
p.Amount,
Deposit as [Deposit Date],
ProcessStatus as [Status],
PrintedDate as [Printed Date],
UID as [ID]
FROM pdc p WITH (NOLOCK)
	JOIN master m WITH (NOLOCK) ON m.number = p.number
WHERE
	deposit >= @startDate and deposit <= @enddate

END

GO
