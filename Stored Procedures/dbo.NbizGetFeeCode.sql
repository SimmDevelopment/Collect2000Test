SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[NbizGetFeeCode]
@Customer as varchar(7)
 AS
declare @Newfeecode as varchar(30)
select @NewFeeCode = feecode from customer where customer = @customer
update nbmaster
	set feecode = @NewFeeCode







GO
