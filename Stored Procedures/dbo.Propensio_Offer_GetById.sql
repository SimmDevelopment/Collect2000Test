SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ryan Mack
-- Create date: 2017-07-12
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_Offer_GetById] 
	@id UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

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
	WHERE SettlementOffers.Id = @id
	Order by SettlementOffers.Id, Tier, [Priority], [SuggestedPaymentDate]

END

GO
