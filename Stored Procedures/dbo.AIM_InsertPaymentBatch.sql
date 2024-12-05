SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_InsertPaymentBatch     */

CREATE procedure [dbo].[AIM_InsertPaymentBatch]
(
	 @paymenttype varchar(3)
	,@paymentbatchcount int = 1
)
as
set nocount on

-- Get the batch payment type
declare @batchpaymenttype int
select @batchpaymenttype = dbo.AIM_PaymentTypeNumber(@paymenttype)

-- Get the next payment batch number
declare @nextpaymentbatch int
exec AIM_GetNextPaymentBatch @nextpaymentbatch output

-- Get the system month and year
declare @systemmonth smallint
declare @systemyear smallint
select	@systemmonth = currentmonth
	   ,@systemyear = currentyear
from dbo.ControlFile 


	insert into dbo.paymentbatches
	(
		 batchnumber
		,batchtype
		,createddate
		,lastammended
		,itemcount
		,sysmonth
		,sysyear
	)
	values
	(
		 @nextpaymentbatch
		,@batchpaymenttype
		,getdate()
		,getdate()
		,@paymentbatchcount
		,@systemmonth
		,@systemyear	
	)

-- Return the next payment batch number
select @nextpaymentbatch as 'nextpaymentbatch'
	
return



GO
