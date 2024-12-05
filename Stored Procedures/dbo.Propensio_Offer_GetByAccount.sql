SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ryan Mack
-- Create date: 2017-07-12
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_Offer_GetByAccount] 
	@AccountId NVARCHAR(MAX),
	@IncludeExpired BIT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @FileNum INT
	DECLARE @Balance MONEY

	SET @FileNum = CONVERT(INT, @AccountId)
	SELECT @Balance = current0 FROM master WHERE number = @FileNum

	IF(@IncludeExpired = 0)
	BEGIN
		DECLARE @NeedsRefresh INT

		SELECT @NeedsRefresh = COUNT(*)
		FROM SettlementOffers 
		WHERE AccountId = @AccountId AND ExpirationDate >= GETDATE()

		IF (@NeedsRefresh = 0)
		BEGIN
			EXEC Propensio_Offer_Build @AccountId, @Balance
		END
	END

	SELECT 
		SettlementOffers.Id,
		SettlementOffers.AccountId,
		SettlementOffers.PolicyId,
		SettlementOffers.ExpirationDate,
		SettlementOffers.Priority,
		SettlementOffers.Description,
		SettlementOffers.TotalAmount,
		SettlementOffers.IsSettlement,
		SettlementOffers.Tier,
		SettlementOffers.Code,
		SettlementOffers.UtcCreated,
		SettlementOffers.UtcUpdated,
		SettlementOffers.UtcConverted,
		FuturePayments.Id [FuturePaymentId],
		FuturePayments.SuggestedPaymentDate as [SuggestedPaymentDate],
		FuturePayments.MinDate as [MinDate],
		FuturePayments.MaxDate as [MaxDate],
		FuturePayments.SuggestedPaymentAmount,
		FuturePayments.MinPaymentAmount,
		FuturePayments.MaxPaymentAmount
	FROM SettlementOffers 
		INNER JOIN FuturePayments ON SettlementOffers.Id = SettlementOfferId 
	WHERE SettlementOffers.AccountId = @AccountId 
		AND (@IncludeExpired = 1 OR ExpirationDate >= GETDATE())
	ORDER BY SettlementOffers.Id, Tier, [Priority], SuggestedPaymentDate
END

GO
