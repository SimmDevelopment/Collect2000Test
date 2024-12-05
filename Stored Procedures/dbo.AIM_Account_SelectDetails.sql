SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                procedure [dbo].[AIM_Account_SelectDetails] 
(
      @referenceNumber   int
)
AS
BEGIN
--Modified to include the can recall and replace field to the dataset
DECLARE @canrecallandreplace BIT
DECLARE @isplaced BIT,@currentagencyid INT,@haspendingtransaction BIT
DECLARE @message VARCHAR(1000)
SELECT @isplaced = isplaced,@currentagencyid = currentlyplacedagencyid FROM aim_accountreference WITH (NOLOCK)
WHERE referencenumber = @referencenumber

IF(@isplaced = 1)
BEGIN
	IF EXISTS(SELECT agencyid FROM AIM_AccountTransaction ATR WITH (NOLOCK)
	JOIN AIM_AccountReference AR WITH (NOLOCK) ON ATR.AccountReferenceID = AR.AccountReferenceID
	WHERE TransactionTypeID = 3 AND TransactionStatusTypeID = 1 AND AgencyID = @currentagencyid AND AR.ReferenceNumber = @referenceNumber)
	BEGIN
		SET @message = 'Account has a Final Recall transaction ready for {0}'
		SET @haspendingtransaction = 1
	END
	ELSE
	BEGIN
		SET @message = 'Account is currently placed to {0}'
		SET @haspendingtransaction = 0
		IF EXISTS(SELECT agencyid FROM aim_accounttransaction atr WITH (NOLOCK)
		JOIN aim_accountreference ar WITH (NOLOCK) ON atr.accountreferenceid = ar.accountreferenceid and ar.referencenumber = @referencenumber and ar.currentlyplacedagencyid <> atr.agencyid
		WHERE transactiontypeid = 1 AND transactionstatustypeid = 3 AND validplacement = 1)
		SET @canrecallandreplace = 1
		ELSE
		SET @canrecallandreplace = 0
	END
END
ELSE
	IF EXISTS(SELECT agencyid FROM AIM_AccountTransaction ATR WITH (NOLOCK)
	JOIN AIM_AccountReference AR WITH (NOLOCK) ON ATR.AccountReferenceID = AR.AccountReferenceID
	WHERE TransactionTypeID = 1 AND TransactionStatusTypeID = 1 AND AR.ReferenceNumber = @referenceNumber)
	BEGIN
		SET @message = 'Account has a Placement Transaction ready'
		SET @haspendingtransaction = 1
	END
	ELSE
	BEGIN
		SET @message = 'Account is not placed'
		SET @canrecallandreplace = 0
		SET @haspendingtransaction = 0
	END




SELECT
		[Agency/Attorney Name] =
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed' 
			ELSE a.Name END  
		,[Agency/Attorney AlphaCode] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed' 
			ELSE a.AlphaCode END 
		,[Agency/Attorney ID] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed' 
			ELSE CAST(a.AgencyID AS VARCHAR) END  
		,[Agency/Attorney Tier] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed' 
			ELSE CAST(a.AgencyTier aS VARCHAR) END 
		,[Has Acknowledged Placement] = 
			CASE ISNULL(AR.IsPlaced,0) WHEN 0 THEN 'Not Currently Placed' 
			ELSE CASE AgencyAcknowledgement WHEN 1 THEN 'Yes' 
			ELSE 'No' END END
		,[Current Fee Status] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed'
			ELSE CASE ISNULL(AR.CurrentCommissionPercentage,0) WHEN 0 THEN 'Fee Schedule=' + CAST(AR.FeeSchedule AS VARCHAR) 
			ELSE CAST(AR.CurrentCommissionPercentage AS VARCHAR) + ' %' END END
		,[Current Final Recall Objection Status] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed'
			ELSE CASE ISNULL(ObjectionFlag,0) WHEN 1 THEN 'Currently Being Objected to a Final Recall' 
			ELSE 'No Objections' END END
		,[Last Placed On] = 
			CASE WHEN LastPlacementDate IS NULL THEN 'Not Currently Placed'
			ELSE CONVERT(VARCHAR,LastPlacementDate,121) END
		,[Last Recalled On] = 
			CASE WHEN LastRecallDate IS NULL THEN 'Never Recalled' 
			ELSE CONVERT(VARCHAR,LastRecallDate,121) END
		,[Next Automatic Pending Recall On] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed'
			ELSE CASE WHEN ExpectedPendingRecallDate IS NULL THEN 'No Auto Recalls for this Account' 
			ELSE CONVERT(VARCHAR,ExpectedPendingRecallDate,121) END END
		,[Next Automatic Final Recall On] = 
			CASE WHEN ISNULL(AR.IsPlaced,0) = 0 THEN 'Not Currently Placed'
			ELSE CASE WHEN ExpectedFinalRecallDate IS NULL THEN 'No Auto Recalls for this Account' 
			ELSE CONVERT(VARCHAR,ExpectedFinalRecallDate,121) END END
		,[Placed Balance] = 
			CASE WHEN IsPlaced IS NULL THEN 0 ELSE
			CASE IsPlaced WHEN 1 THEN ISNULL(dbo.AIM_GetCurrentlyPlacedBalance(M.number),0)
			ELSE 0
			END END
		,[Current Balance] = M.Current0 
		,[Can Recall And Replace] = @canrecallandreplace
		,[Is Placed] = ISNULL(AR.IsPlaced,0)
		,[Current Status] = @message
		,[Has Pending Transaction] = @haspendingtransaction
FROM
		dbo.Master [M] WITH (NOLOCK)
		LEFT OUTER JOIN AIM_AccountReference AR WITH (NOLOCK)
		ON AR.ReferenceNumber = M.Number AND M.Number = @referenceNumber
		LEFT OUTER JOIN AIM_Agency A WITH (NOLOCK)
		ON A.AgencyID = AR.CurrentlyPlacedAgencyID
WHERE M.Number = @referenceNumber


END

GO
