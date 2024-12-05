SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Payment_ProcessLedgerEntry]
@AccountID INT,
@DatePaid DATETIME,
@Comment VARCHAR(50),
@Amount MONEY,
@AIMID INT,
@AIMUniqueID VARCHAR(50),
@AIMInvoiceID  VARCHAR(50),
@LegalLedgerTypeID INT

AS

BEGIN

DECLARE @processFlag INT
SET @processFlag = 1
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_NAME = 'AIM_Custom_ProcessLegalLedgerEntry' AND ROUTINE_TYPE='PROCEDURE' )
BEGIN
EXEC @processFlag = AIM_Custom_ProcessLegalLedgerEntry @AccountID,@DatePaid,@Amount,@LegalLedgerTypeID,@AIMUniqueID,@AIMInvoiceID,@AIMID
END
IF(@processFlag = 1)
BEGIN
INSERT INTO Legal_Ledger
(AccountID,Customer,ItemDate,[Description],DebitAmt,CreditAmt,Invoiceable,
LegalLedgerTypeID,AIMID,AIMUniqueID,AIMInvoiceID,Created)
SELECT
@AccountID,
m.Customer,
@DatePaid,
@Comment,
CASE WHEN (llt.IsDebit = 1 AND @Amount > 0 ) OR (llt.IsDebit = 0 AND @Amount < 0) THEN ABS(@Amount) ELSE 0 END,
CASE WHEN (llt.IsDebit = 1 AND @Amount < 0 ) OR (llt.IsDebit = 0 AND @Amount > 0) THEN ABS(@Amount) ELSE 0 END,
llt.Invoiceable,
llt.ID,
@AIMID,
@AIMUniqueID,
@AIMInvoiceID,
GETDATE()
FROM dbo.Master m WITH (NOLOCK),LegalLedgerType llt WITH (NOLOCK)
WHERE llt.ID = @LegalLedgerTypeID AND m.Number = @AccountID
END
ELSE
BEGIN
RAISERROR('Legal Ledger Entry Not Inserted due to Custom Logic',16,1)
RETURN
END
END

GO
