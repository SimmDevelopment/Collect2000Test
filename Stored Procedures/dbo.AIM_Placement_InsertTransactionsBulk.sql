SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[AIM_Placement_InsertTransactionsBulk]

AS
BEGIN

	declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	while @@rowcount>0
	begin
		set rowcount @sqlbatchsize
		INSERT  INTO AIM_AccountReference
		(ReferenceNumber)
		SELECT
		ppa.Number
		FROM AIM_PlacementPendingAccounts ppa WITH (NOLOCK) LEFT OUTER JOIN AIM_AccountReference ar WITH (NOLOCK)
		ON ppa.Number = ar.referencenumber WHERE ar.referencenumber is null
	end
	set rowcount 0

	declare @ppa table (tid int identity(1,1) primary key, number int)
	insert into @ppa (number) select number from AIM_PlacementPendingAccounts

	select @maxid= max(tid) from @ppa
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end

	while @rowcount <= @maxid
	begin

		INSERT INTO AIM_AccountTransaction  with (rowlock) 
		(AccountReferenceId,TransactionTypeId,TransactionStatusTypeId,CreatedDateTime,AgencyId,CommissionPercentage,Balance,FeeSchedule,Desk)
		SELECT
		ar.AccountReferenceId,
		1,
		1,
		getdate(),
		da.AgencyId,
		da.CommissionPercentage,
		m.current0,
		da.feeschedule,
		da.Desk

		FROM @ppa p
		JOIN AIM_PlacementPendingAccounts ppa WITH (NOLOCK) on p.number = ppa.number 
		JOIN master m WITH (NOLOCK) ON ppa.Number = m.number
		JOIN AIM_DistributionAgency da WITH (NOLOCK) ON ppa.DistributionAgencyId = da.DistributionAgencyId
		JOIN AIM_AccountReference ar WITH (NOLOCK) ON ar.referencenumber = ppa.number
		where p.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end

	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	
	select @maxid= max(tid) from @ppa
	select @currentrow = 1 
	select @rowcount = case when @sqlbatchsize<=@maxid then @sqlbatchsize else @maxid end
	while @rowcount <= @maxid
	begin
		UPDATE  AIM_AccountReference  
		SET IsPlaced = 0,
		lastPlacementDate = null,
		expectedPendingRecallDate = null,
		expectedFinalRecallDate = null,
		numdaysplacedbeforepending = CASE dt.AutoRecallOn WHEN 1 THEN dt.PreRecallNoticeDays ELSE null END,
		numdaysplacedafterpending = CASE dt.AutoRecallOn WHEN 1 THEN dt.recallNoticeDays ELSE null END,
		CurrentlyplacedagencyId = null,
		CurrentCommissionPercentage = null,
		FeeSchedule = null,
		RecallDesk = da.RecallDesk
		FROM  AIM_PlacementPendingAccounts ppa WITH (NOLOCK) JOIN master m WITH (NOLOCK) ON ppa.Number = m.number
		JOIN AIM_DistributionAgency da WITH (NOLOCK) ON ppa.DistributionAgencyId = da.DistributionAgencyId
		JOIN AIM_DistributionTemplate dt WITH (NOLOCK) ON da.DistributionTemplateId = dt.DistributionTemplateId
		JOIN AIM_AccountReference ar WITH (NOLOCK) ON ar.referencenumber = ppa.number
		JOIN @ppa p ON p.number = ppa.number
		where  p.tid between @currentrow and @rowcount

		select @currentrow = @rowcount + 1
		select @rowcount= case when @rowcount + @sqlbatchsize <@maxid  then @rowcount + @sqlbatchsize
							   when @rowcount = @maxid then @maxid+1 
						  else @maxid end
	end
	
	DELETE FROM AIM_PlacementPendingAccounts
END



GO
