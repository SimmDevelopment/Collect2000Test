SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--ALTER  the procedure.
CREATE  PROCEDURE [dbo].[Custom_HSBC_Vegas_Retail_Recon]
@Customer varchar(7)

AS
-- Variable declaration.
DECLARE @batchDate varchar(50)
-- Variable assignment.
SET @batchDate = REPLACE(CONVERT(char, GetDate(), 101), '/', '')


SELECT 


m.account as Account,
d.lastname AS LastName,
d.firstname AS FirstName,
(SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'Account_Status') as Status,
@BatchDate as FileDate,
REPLACE(CONVERT(char, m.received, 101), '/', '') AS AccountStatusDate,
c.customtext1 as RecovererID,
'510335159' AS TaxID,
[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(9),ISNULL(m.lastpaidamt, 0.00)),9,1) as LastPaidAmount,
REPLACE(CONVERT(char, m.lastpaid, 101), '/', '') as LastPaid,
[dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(9),ISNULL(m.current0, 0.00)),9,1) as Balance
       
       
       
FROM Master as m WITH (NOLOCK)
INNER JOIN customer c WITH(NOLOCK)
on c.customer = m.customer INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE m.QLevel not in ('998','999') and 
      m.Customer = @customer

GO
