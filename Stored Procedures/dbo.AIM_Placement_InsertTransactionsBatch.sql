SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--This sproc is used by AIM when making placements via Business Rules
CREATE  PROCEDURE [dbo].[AIM_Placement_InsertTransactionsBatch]
  @sqlBatchSize INT = 1000 --Default
AS
BEGIN

	create table #ppa (tid int identity(1,1) primary key, number int)
	declare @executeSQL varchar(500)
	SET @executeSQL = 'INSERT INTO #ppa (number) SELECT TOP ' + CAST(@sqlBatchSize AS VARCHAR(16)) + ' Number FROM AIM_PlacementPendingAccounts'
	EXEC(@executeSQL)

--Push in accounts that have never been placed
	INSERT  INTO AIM_AccountReference
	(ReferenceNumber)
	SELECT
	p.Number
	FROM #ppa p LEFT OUTER JOIN AIM_AccountReference ar WITH (NOLOCK)
	ON p.Number = ar.referencenumber WHERE ar.referencenumber is null

--Insert Transactions	
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

	FROM #ppa p
	JOIN AIM_PlacementPendingAccounts ppa WITH (NOLOCK) on p.number = ppa.number 
	JOIN master m WITH (NOLOCK) ON ppa.Number = m.number
	JOIN AIM_DistributionAgency da WITH (NOLOCK) ON ppa.DistributionAgencyId = da.DistributionAgencyId
	JOIN AIM_AccountReference ar WITH (NOLOCK) ON ar.referencenumber = ppa.number

--Update AIM Account Reference table	
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
	JOIN #ppa p ON p.number = ppa.number
	
--Remove Accounts Just Inserted
	DELETE AIM_PlacementPendingAccounts 
	FROM AIM_PlacementPendingAccounts appa
	JOIN #ppa p ON appa.Number = p.number

--Return what is left to place
	DECLARE @RETURNVALUE INT
	SELECT @RETURNVALUE = COUNT(*) FROM AIM_PlacementPendingAccounts
	RETURN @RETURNVALUE
END

GO
