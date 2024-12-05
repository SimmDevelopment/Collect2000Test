SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE       procedure [dbo].[AIM_UpdateLedgerEntry]
(
	@ledgerId int
	,@ledgerTypeId int
	,@comments text
	,@credit money
	,@debit money
	,@dateEntered datetime
	,@dateCleared datetime
	,@portfolioId int
	,@number int
	,@status varchar(25) = null
)
AS

DECLARE @ledgerstatus varchar(12)
--PUSH IN STATUS OF PENDING IF RECOURSE
if(@ledgerTypeId in (4,5,17,18,19,21,22,24,29,30,31,32,33,34,27,28) and @status is null)
BEGIN
SET @ledgerstatus = 'Pending'
END
else
begin
set @ledgerstatus = @status
end

	if(@ledgerId is null or @ledgerId = 0)
	begin
		insert into 
			aim_ledger
		(
			comments
		)
		values
		(
			null
		)

		select
			@ledgerId = @@identity
	end

	update aim_ledger
	set ledgertypeid = @ledgerTypeId,portfolioid = @portfolioid
	where ledgerid = @ledgerId

	update
		aim_ledger
	set
		
		comments = @comments
		,credit = @credit
		,debit = @debit
		,dateentered = @dateentered
		,datecleared = CASE @ledgerstatus WHEN 'Approved' THEN ISNULL(@dateCleared,GETDATE()) ELSE @dateCleared END
		,status = @ledgerstatus
		,number = @number
		,togroupid = case lt.creditgrouptypeid when 0 then s.buyergroupid when 1 then p.sellergroupid when 2 then p.investorgroupid when 3 then -1 when 4 then null else null end
		,fromgroupid  = case lt.debitgrouptypeid when 0 then s.buyergroupid when 1 then p.sellergroupid when 2 then p.investorgroupid when 3 then -1 when 4 then null else null end
		,soldportfolioid = CASE WHEN m.soldportfolio is null or m.soldportfolio = '' THEN -1 ELSE m.soldportfolio END
	from
		aim_ledger l with (nolock) join 
		aim_portfolio p on l.portfolioid = p.portfolioid
		join aim_ledgertype lt with (nolock) on l.ledgertypeid = lt.ledgertypeid
		join master m with (nolock) on m.number = @number
		left outer join aim_portfolio s with (nolock) on s.portfolioid = m.soldportfolio
	where
		ledgerid = @ledgerId

	DECLARE @action varchar(25)
	IF(@ledgerTypeId IN (4,5,18,29,24,19,22,30,31,32,33,34))
	BEGIN
		IF(@ledgerstatus IN ('Pending','Approved','Declined','Requested'))
		BEGIN
			
			SET @action = CASE @ledgerstatus WHEN 'Pending' THEN 'Pending' WHEN 'Approved' THEN 'Approval' WHEN 'Declined' THEN 'Denial' WHEN 'Requested' THEN 'Requesting' END

			EXEC AIM_UpdateAccountAfterRecourseAction @ledgerId,@action,'Exchange'
		END
	END
	ELSE IF(@ledgerTypeId IN (27,28))
	BEGIN
		IF(@ledgerstatus IN ('Pending','Requested','Received','Sent','Not Available'))
		BEGIN
			
			SET @action = CASE @ledgerstatus WHEN 'Pending' THEN 'Pending' WHEN 'Requested' THEN 'Requesting' WHEN 'Received' THEN 'Received' WHEN 'Sent' THEN 'Sending' WHEN 'Not Available' THEN 'NotAvailable' END
			
			EXEC AIM_UpdateAccountAfterMediaAction @ledgerId,@action,'Exchange'

		END
	END


GO
