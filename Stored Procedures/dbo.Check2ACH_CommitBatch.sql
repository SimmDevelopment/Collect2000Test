SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Check2ACH_CommitBatch]
@batch int,
@entered datetime,
@username varchar(50)
AS

SELECT count(*) as [Count],sum(Amount) as [Sum] FROM Check2ACH_BatchDetail WHERE Batch = @batch


DECLARE @nonccletrcode varchar(10)
SELECT @nonccletrcode = NITDLetterCode FROM Pmethod WHERE ID = 7

--INSERT TRANSACTION
INSERT INTO PDC
( [number], [ctl], [PDC_Type], [entered], [onhold], [processed1], [processedflag], [deposit], [amount], [checknbr], [SEQ], [LtrCode], [nitd], [Desk], [customer], [SurCharge], [Printed], [ApprovedBy], [PromiseMode], [ProjectedFee], [UseProjectedFee], [Active], [CollectorFee])
SELECT c.Number,null,7,@entered,null,null,null,PaymentDate,Amount,CheckNumber, 0, @nonccletrcode, null, m.desk, m.customer, 0,0,@username,1,null,0,1,null
FROM master m WITH (NOLOCK) JOIN Check2ACH_BatchDetail c WITH (NOLOCK) ON m.number = c.number
JOIN Check2ACH_Batch b ON b.batch = c.batch
WHERE c.batch = @batch



--DELETE SELECTED DBI
DELETE DebtorBankInfo
FROM DebtorBankInfo dbi JOIN Check2ACH_BatchDetail c on dbi.acctid = c.number
WHERE c.batch = @batch and updatedbi = 1

--INSERT DBI
INSERT INTO DebtorBankInfo
(AcctID,DebtorID,ABANumber,AccountNumber,AccountName,AccountAddress1,AccountAddress2,AccountCity,AccountState,AccountZipcode,BankName,AccountType)
SELECT top 1
c.Number,0,c.abanumber,c.AccountNumber,c.payerName,c.payerstreet1,c.payerstreet2,c.payercity,c.payerstate,c.payerzipcode,c.bankname,c.accounttype
FROM master m WITH (NOLOCK) JOIN Check2ACH_BatchDetail c WITH (NOLOCK) ON m.number = c.number
JOIN debtors d WITH (NOLOCK) ON m.number = d.number and d.seq = 0
WHERE c.batch = @batch

--WRITE NOTE
INSERT INTO Notes (number,created,user0,action,result,comment)
SELECT Number,getdate(),'sys','++++++','++++++','A check was scanned through Check2ACH for ' + cast (Amount as varchar(50)) 
FROM Check2ACH_BatchDetail WHERE Batch = @batch

--UPDATE DOCUMENTATION

--UPDATE BATCH
UPDATE Check2ACH_Batch
SET DateProcessed = getdate(),
ProcessedBy = @username
WHERE Batch = @batch






GO
