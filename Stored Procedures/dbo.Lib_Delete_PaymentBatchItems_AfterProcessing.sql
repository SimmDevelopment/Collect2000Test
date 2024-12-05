SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Lib_Delete_PaymentBatchItems_AfterProcessing] @UID INTEGER
AS
SET NOCOUNT ON;
DECLARE @Err int;

DELETE FROM [dbo].[PODPmtBatchDetail]
WHERE [BatchItemsId] = @UID;

SET @Err = @@ERROR;
IF @Err <> 0 RETURN @Err;

DELETE FROM [dbo].[PaymentBatchItems]
WHERE [uid] = @UID;

SET @Err = @@ERROR;
IF @Err <> 0 RETURN @Err;

RETURN 0;



GO
