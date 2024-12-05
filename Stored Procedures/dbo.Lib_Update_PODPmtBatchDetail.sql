SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 9/26/2008
-- Description:	updates the paid and fee amounts on a PODPmtBatchDetail record...
-- =============================================
CREATE PROCEDURE [dbo].[Lib_Update_PODPmtBatchDetail] 
	@UID int,
	@Paid money,
	@Fee money
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE PODPmtBatchDetail SET PaidAmt = @Paid, FeeAmt = @Fee
	WHERE UID = @UID

	RETURN @@ERROR
END


GO
