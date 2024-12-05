SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--ALTER  the procedure.
CREATE  PROCEDURE [dbo].[getToyotaAudit]
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
       ' '  AS SortType,
       LEFT(REPLACE(m.name,',',' '),20) as LastName,
--       CASE m.Status
--          WHEN 'B11' THEN 'AR1'
--          WHEN 'B13' THEN 'AR3'
--          WHEN 'BO7' THEN 'AR7'
--          WHEN 'BKY' THEN 'AR7'
--          WHEN 'DIS' THEN 'ARD'
--          WHEN 'FRD' THEN 'ARF'
--          WHEN 'DIP' THEN 'ARJ'
--          WHEN 'LEG' THEN 'ARL'
--          WHEN 'SIF' THEN 'ARX'
--          WHEN 'PIF' THEN 'ARY'
--          WHEN 'EXP' THEN 'A1U'
--          WHEN 'NWP' THEN 'A1U'
--          WHEN 'AEX' THEN 'A1W'
--          ELSE
--              'A10'
--       END AS Status,
       'A10' as Status,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.current0, 0.00)),11,1) as Balance,
       REPLACE(CONVERT(char, m.Received, 111), '/', '') as DateAssigned,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.original, 0.00)),11,1) as OriginalBalance,
       REPLACE(CONVERT(char, m.lastpaid, 111), '/', '') as LastPaid,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.lastpaidamt, 0.00)),11,1) as LastPaidAmount,
       (SELECT 'Y'
        FROM CourtCases cc WITH (NOLOCK)
        WHERE cc.AccountId = m.number and cc.judgementamt > 0) as JudgementAmount,
       '' as OrgCode,
       '' as AgyAKACode,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.Current1, 0.00)),13,1) as PrincipalBalance,
       [dbo].[Custom_ConvertNumberToIBMSigned](CONVERT(varchar(11),ISNULL(m.Current2, 0.00)),13,1) as InterestBalance,
       @ZeroFilledNumeric13 as CostBalance,
       @ZeroFilledNumeric13 as Udc1Balance,
	@ZeroFilledNumeric13 as Udc2Balance,
	@ZeroFilledNumeric13 as Udc3Balance,
	@ZeroFilledNumeric13 as Udc4Balance,
	@ZeroFilledNumeric13 as Udc5Balance, 
	@ZeroFilledNumeric13 as Udc6Balance,
	@ZeroFilledNumeric13 as Udc7Balance,
	@ZeroFilledNumeric13 as Udc8Balance,
	@ZeroFilledNumeric13 as Udc9Balance,
	@ZeroFilledNumeric13 as Udc10Balance,
	@ZeroFilledNumeric13 as Udc11Balance,
	@ZeroFilledNumeric13 as Udc12Balance,
	@ZeroFilledNumeric13 as ExcessBalance,
       c.CustomText2 AS LoanCode,
       (Select top 1 me.TheData from MiscExtra me WITH (NOLOCK)
        WHERE (me.number = m.number) and 
              (me.Title like '%Lending Officer%')) 
       as OfficerCode,
       '' as MiscCode1, 
       '' as MiscCode2, 
       'B' as FormatCode,
       '' as Modifier
FROM Master as m WITH (NOLOCK)
INNER JOIN customer c WITH(NOLOCK)
on c.customer = m.customer 
WHERE m.QLevel not in ('998','999') and 
      m.Customer = @customer

GO
