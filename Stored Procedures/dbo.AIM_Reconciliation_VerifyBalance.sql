SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[AIM_Reconciliation_VerifyBalance]
(
  		@file_number   int
 		,@account varchar(30)
	,@original_balance money
	,@received_date datetime
	,@current_balance money
	,@last_payment_date   datetime
	,@last_payment_amount   money
	,@agencyId int
	,@overWriteBalance bit
)
as
begin

	-- verify account
	declare @masterNumber int
	declare @currentaccount varchar(30)
	declare @current0 money,@currentAgencyId int
	select 	@masterNumber = m.number ,@current0 = current0,@currentAgencyId=currentlyplacedagencyid,@account = account
	from 	master m with (nolock)
		left outer join aim_accountreference r on m.number = r.referencenumber
	where 	m.number = @file_number

	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	
	if(@currentAgencyId is null or(@currentAgencyId <> @agencyId))
	begin
		raiserror ('15004', 16, 1)
		return
	end

	if(@account <> @currentaccount )
	begin
		raiserror ('15009', 16, 1)
		return
	end
	
	if(abs(cast(@current0 as decimal(15,4)) - cast(@current_balance as decimal(15,4))) > .01)
	begin
		if(@overWriteBalance = 0)
		begin
			RAISERROR ('15002', 16, 1)
			return
		end
		else if(@overWriteBalance = 1)
		begin
			update master set current0 = @current_balance where number = @file_number
			raiserror ('150021',16,1)
			return
		end
	end

INSERT INTO NOTES (Number,Created,User0,[Action],[Result],Comment)
SELECT
@masterNumber,GETDATE(),'AIM','AIM','AIM','Processed AREC record on Account from Agency/Attorney  - ' + a.Name
FROM AIM_Agency a WHERE a.AgencyID = @agencyId
end







GO
