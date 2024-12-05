SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [dbo].[NameAddressInsert]
	@TransType_2 	[varchar](1),
	 @Desk_4 	[varchar](7),
	 @Number_5 	[real],
	 @OStatus_6 	[varchar](5)

AS 

declare @TransDate_1 	datetime
declare @name varchar(30)
declare @status varchar(5)
declare @customer varchar(7)
declare @account varchar(30)

set @transDate_1 = getdate()

select @status=status,@account=account,@customer=customer,@name=name from master where number = @number_5

INSERT INTO [dbo].[NameAddress] 
	 ( [TransDate],
	 [TransType],
	 [Desk],
	 [Number],
	 [OStatus],
	 [Nstatus],
	 [TransmittedYes],
	 [Account],
	 [Customer],
	 [name]) 
 
VALUES 
	( @TransDate_1,
	 'S',
	 @Desk_4,
	 @Number_5,
	 @OStatus_6,
	 @status,
	 'N',
	 @account,
	 @customer,
	 @name)









GO
