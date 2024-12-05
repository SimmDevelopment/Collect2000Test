SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[AIM_Recall_InsertTransaction]
(
      @referenceNumber   int
	,@finalRecall 	char(1) -- 'Y' or 'N'
	,@recallReasonCode int = null
	,@recallDesk varchar(10) = null
)
as
begin
	declare @accountReferenceId int
	declare @agencyId int
	select
		@accountReferenceId = accountreferenceid
		,@agencyId = currentlyplacedagencyid
	from
		AIM_accountreference
	where
		referenceNumber = @referenceNumber

	-- if no account reference record then create one
	if(@accountReferenceId is null)
	begin
		insert into AIM_accountreference 
		(
			referencenumber
			,isplaced
		)
		values
		(
			@referenceNumber
			,0
		)

		select
			@accountReferenceId = @@Identity
	end

	declare @pendingtransactions table(accounttransactionid int)
	insert into @pendingtransactions
		select
			accounttransactionid
		from
			AIM_accounttransaction atr
			join AIM_accountreference ar on ar.accountreferenceid = atr.accountreferenceid
		where
			atr.transactiontypeid in (2,3) -- pending or final recall
			and atr.transactionstatustypeid <> 3 -- completed
			and ar.referencenumber = @referencenumber

	-- verify we aren't already waiting to process this transaction
	declare @count int
	select @count = count(*) from @pendingtransactions
	if( @count <= 0)
	begin
		insert into AIM_accounttransaction 
		(
			accountreferenceid
			,batchfilehistoryid
			,transactiontypeid
			,transactioncontext
			,transactionstatustypeid
			,createddatetime
			,completeddatetime
			,agencyid
			,logmessageid
			,tier
			,commissionpercentage
			,balance
			,paymentbatchnumber
			,recallreasoncodeid
			,desk
		)
		values
		(
			@accountReferenceId
			,null
			,case
				when @finalRecall = 'Y' then 3 -- final recall type
				when @finalRecall = 'N' then 2
				else 2
			end
			,null --transaction context
			,1 -- open status type
			,getdate()
			,null -- completed date
			,@agencyId
			,null
			,null
			,null
			,null
			,null
			,@recallReasonCode
			,@recalldesk
		)	
	end


end

GO
