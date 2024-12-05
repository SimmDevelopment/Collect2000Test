SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     FUNCTION [dbo].[AIM_WasPlaced]
	(
		@atDate datetime,
		@agencyId int,
		@number int
	)
returns int
as
	begin

		set @atDate = @atdate + 1 -- entered date on payments doesn't have time

		declare @lastPlacementBeforeDate datetime

		select 
			top 1
			@lastPlacementBeforeDate = atr.completeddatetime
		from 
			AIM_accounttransaction atr
			join AIM_accountreference ar on ar.accountreferenceid = atr.accountreferenceid
		where 
			atr.transactiontypeid = 1 -- placement
			and atr.completeddatetime < @atDate 
			and agencyid = @agencyId
			and transactionstatustypeid = 3
			and ar.referencenumber = @number
		order by
			atr.completeddatetime desc

		if(@lastPlacementBeforeDate is null)  -- never been placed there
			return 0

		declare @nextRecallAfterPlacement datetime
		select 
			top 1
			@nextRecallAfterPlacement = atr.completeddatetime
		from 
			AIM_accounttransaction atr
			join AIM_accountreference ar on ar.accountreferenceid = atr.accountreferenceid
		where 
			atr.transactiontypeid = 3 -- final recall
			and atr.completeddatetime > @lastPlacementBeforeDate 
			and agencyid = @agencyId
			and transactionstatustypeid = 3
			and ar.referencenumber = @number
		order by
			atr.completeddatetime

		set @atDate = cast(month(@atdate) as varchar(10))+'/'+cast(day(@atdate) as varchar(10))+'/'+cast(year(@atdate) as varchar(10)) 

		if(@nextRecallAfterPlacement is null) -- hasn't been recalled yet
			return 1

		if(@atDate < @nextRecallAfterPlacement)
			return 1

		if(@atDate > @nextRecallAfterPlacement)
			return 0

		return 2 -- shouldn't get here

	end






GO
