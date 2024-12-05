SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Mike Devlin
-- Create date: 6/30/2008
-- Description:	inserts a record...
-- =============================================
CREATE PROCEDURE [dbo].[Lib_Insert_PODPmtBatchDetail] 
	@BatchItemID int,
	@PODID int,
	@Paid money,
	@Fee money,
	@BatchType tinyint
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO PODPmtBatchDetail(BatchItemsID, PODID, PaidAmt, FeeAmt, Batchtype)
	VALUES (@BatchItemID, @PODID, @Paid, @Fee, @BatchType)

	RETURN @@ERROR
END


GO
