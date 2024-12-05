SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   procedure [dbo].[AIM_GetNextPaymentBatch]
	(
		@nextpaymentbatch int output
	)
AS

	select @nextpaymentbatch = max(batchnumber) + 1 from paymentbatches
	update AIM_ControlFileView
	set x2 = @nextpaymentbatch

	RETURN 

GO
