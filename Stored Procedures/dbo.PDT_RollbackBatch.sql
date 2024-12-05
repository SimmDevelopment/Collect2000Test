SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[PDT_RollbackBatch]
@batchId int
AS
DELETE FROM PaymentBatchItems WHERE BatchNumber = @batchId
DELETE FROM PaymentBatches WHERE BatchNumber = @batchId

DECLARE @Version INT
SELECT @Version = CAST(LEFT(SoftwareVersion,1) AS INT) FROM CONTROLFILE

IF(@Version > 7)
BEGIN
	DELETE FROM PaymentBatchLock WHERE BatchNumber = @batchId
END

UPDATE PDC SET Active = 1
FROM PDC p WITH (NOLOCK) JOIN PDTTemp pp WITH (NOLOCK)
ON p.uid = pp.pdtid AND pp.IsCreditCard = 0 AND BatchID = @batchId


UPDATE DebtorCreditCards SET IsActive = 1 
FROM DebtorCreditCards d WITH (NOLOCK) JOIN PDTTemp pp WITH (NOLOCK)
ON d.id = pp.pdtid AND pp.IsCreditCard = 1 AND BatchID = @batchId

DELETE FROM PDTTemp WHERE BatchID = @batchId

GO
