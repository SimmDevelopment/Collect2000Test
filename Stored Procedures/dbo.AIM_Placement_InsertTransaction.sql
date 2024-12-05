SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[AIM_Placement_InsertTransaction]
(
      @referenceNumber   int,
      @distributionAgencyId   int
)
as
begin

	declare @agencyId int
	declare @commissionPercentage float
	declare @autoRecallOn bit
	declare @beforePendingDays int
	declare @afterPendingDays int
	declare @feeSchedule varchar(5)
	declare @desk varchar(10)
	declare @recallDesk varchar(10)
	-- get some parameters for placements
	select	@agencyId = da.agencyId
			,@commissionPercentage = da.commissionPercentage
			,@autoRecallOn = dt.autoRecallOn
			,@beforePendingDays = dt.PreRecallNoticeDays
			,@afterPendingDays = dt.recallNoticeDays
			,@feeSchedule = da.feeschedule
			,@desk = da.desk		
			,@recallDesk = da.RecallDesk
	from	AIM_DistributionAgency da
			join AIM_DistributionTemplate dt on dt.distributiontemplateid = da.distributiontemplateid
	where	da.distributionAgencyId = @distributionAgencyid

	exec [AIM_Placement_InsertTransactionDirectly] @referencenumber, @agencyid, @commissionpercentage, @autorecallon, @beforependingdays, @afterpendingdays , @feeschedule, @desk, @recallDesk
end
GO
