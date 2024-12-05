SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spPaymentBatch_Delete] @BatchNumber INTEGER
AS
SET NOCOUNT ON;

BEGIN TRANSACTION;

UPDATE [dbo].[Promises]
set [PaymentLinkUID] = NULL
where
[PaymentLinkUID] in 
(select [PaymentLinkUID] from [dbo].[PaymentBatchItems]
where [BatchNumber] = @BatchNumber)

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE [dbo].[pdc]
SET [Active] = 1
FROM [dbo].[pdc]
INNER JOIN [dbo].[PaymentBatchItems]
ON [PaymentBatchItems].[PostDateUID] = [pdc].[UID]
AND [PaymentBatchItems].[FileNum] = [pdc].[number]
WHERE [PaymentBatchItems].[SubBatchType] = 'PDC'
AND [PaymentBatchItems].[PostDateUID] IS NOT NULL
AND [PaymentBatchItems].[BatchNumber] = @BatchNumber;

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE [dbo].[DebtorCreditCards]
SET [IsActive] = 1
FROM [dbo].[DebtorCreditCards]
INNER JOIN [dbo].[PaymentBatchItems]
ON [PaymentBatchItems].[PostDateUID] = [DebtorCreditCards].[ID]
AND [PaymentBatchItems].[FileNum] = [DebtorCreditCards].[Number]
WHERE [PaymentBatchItems].[SubBatchType] = 'PCC'
AND [PaymentBatchItems].[PostDateUID] IS NOT NULL
AND [PaymentBatchItems].[BatchNumber] = @BatchNumber;

IF @@ERROR <> 0 GOTO ErrorHandler;

DELETE FROM [dbo].[PODPmtBatchDetail]
WHERE [BatchItemsId] IN (SELECT uid FROM PaymentBatchItems WHERE batchnumber = @BatchNumber);

IF @@ERROR <> 0 GOTO ErrorHandler;

DELETE FROM [dbo].[PaymentBatchItems]
WHERE [BatchNumber] = @BatchNumber;

IF @@ERROR <> 0 GOTO ErrorHandler;

DELETE FROM [dbo].[PaymentBatches]
WHERE [BatchNumber] = @BatchNumber;

IF @@ERROR <> 0 GOTO ErrorHandler;

COMMIT TRANSACTION;

RETURN 0;
ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;
GO
