SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--ALTER  the procedure.
CREATE  PROCEDURE [dbo].[Custom_USBANK_Export_Audit]
@Customer varchar(7)
AS
-- Variable declaration.
DECLARE @batchDate varchar(50)
DECLARE @Customers VARCHAR(50)
DECLARE @ZeroFilledNumeric13 varchar(13)
-- Variable assignment.
SET @ZeroFilledNumeric13 = '000000000000{'
SET @batchDate = REPLACE(CONVERT(char, GetDate(), 111), '/', '')
SELECT @BatchDate as FileDate,
	c.customtext1 as RecovererID,
       m.account as Account,
       LEFT(REPLACE(m.name,',',' '),20) as LastName,
       'AG2' as Status,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.current0, 0.00)),11,1) as Balance,
       REPLACE(CONVERT(char, m.Received, 111), '/', '') as DateAssigned,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.original, 0.00)),11,1) as OriginalBalance,
       REPLACE(CONVERT(char, m.lastpaid, 111), '/', '') as LastPaid,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.lastpaidamt, 0.00)),11,1) as LastPaidAmount,
       (SELECT 'Y'
        FROM CourtCases cc WITH (NOLOCK)
        WHERE cc.AccountId = m.number and cc.judgementamt > 0) as JudgementAmount
       
FROM Master as m WITH (NOLOCK)
INNER JOIN customer c WITH(NOLOCK)
on c.customer = m.customer 
WHERE m.QLevel not in ('998','999') and 
      m.Customer = @customer

GO
