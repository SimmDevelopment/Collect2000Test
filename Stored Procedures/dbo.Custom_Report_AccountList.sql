SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Client Account#, Client Name, Customer Name, Current Status, Date of Status, Active/Not Active, Received Date, Last Payment Date, Last Payment Amount, Current Balance 

CREATE PROCEDURE [dbo].[Custom_Report_AccountList]
@date datetime
AS

SELECT m.account [Account #], m.name [Client name], c.name [Customer Name], m.status [Current Status],
	(SELECT TOP 1 DateChanged FROM StatusHistory WHERE AccountID = m.number ORDER BY DateChanged DESC) [Status Date],
	CASE WHEN s.statustype = '0 - Active' THEN 'Active' ELSE 'Closed' END [Active/Closed],
	received [Received Date], lastpaid [Last Payment Date], lastpaidamt [Last Payment Amount],
	current0 [Current Balance]
FROM master m INNER JOIN status s
	ON m.status = s.code INNER JOIN customer c
	ON m.customer = c.customer INNER JOIN Custom_AccountList al
	ON m.account = al.Account AND m.customer = al.Customer 
WHERE al.Date = @date
GO
