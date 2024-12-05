SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Custom_PreviousPaymentsForReversalValidation] 
@number int,
@amount money,
@batchtype varchar (50),
@reversalbatchtype varchar(50)

as

select entered,uid from payhistory 
where number = @number 
and batchtype = @batchtype and 
totalpaid = @amount


select entered,reverseofuid from payhistory 
where number = @number 
and batchtype = @reversalbatchtype and 
totalpaid = @amount

GO
