SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_PC_NoComm]
	-- Add the parameters for the stored procedure here
	@number int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE PaymentBatchItems
SET fee0 = 0, fee1 = 0, fee2 = 0, fee3 = 0, fee4 = 0, CollectorFee = 0
WHERE FileNum = @number AND SubBatchType = 'NB'	

END
GO
