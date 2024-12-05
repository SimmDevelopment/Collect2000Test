SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_Offer_50SIF]
	-- Add the parameters for the stored procedure here
	@AccountId AS int,
	@Balance AS Money
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SettlementId AS UNIQUEIDENTIFIER
	DECLARE @SettlementAmount AS MONEY
	DECLARE @Tier INT --Zero based. Each tier is presented to the consumer in order
	SET @Tier = 0

    -- Insert statements for procedure here
	SET @SettlementId = NEWID()
	SET @SettlementAmount = ROUND(@Balance / 2, 2)

	INSERT INTO [dbo].[SettlementOffers]
           ([Id]
           ,[AccountId]
           ,[PolicyId]
           ,[ExpirationDate]
           ,[Priority]
           ,[Description]
           ,[TotalAmount]
           ,[IsSettlement]
           ,[Tier]
           ,[Code]
           ,[UtcCreated]
           ,[UtcUpdated])
     VALUES
           (@SettlementId,
			@AccountId,
			'',
			DATEADD(d, 1, GETDATE()),
			1, --Priority within each tier determines the order on the screen. (Order by Tier, Priority)
			'50% Settlement Offer',
			@SettlementAmount,
			1,
			@Tier,
           '50SIF', -- This is arbitrary. Can be used for reporting/metrics
           GETDATE(),
		   GETDATE())
		   
		   
--Insert payment into Propensio Database
	INSERT INTO [dbo].[FuturePayments]
           ([Id]
           ,[SettlementOfferId]
           ,[SuggestedPaymentDate]
           ,[MinDate]
           ,[MaxDate]
           ,[SuggestedPaymentAmount]
           ,[MinPaymentAmount]
           ,[MaxPaymentAmount])
     VALUES
           (NEWID(),
			@SettlementId,
			GETDATE(),
			GETDATE(),
			GETDATE(),
			@SettlementAmount,
			@SettlementAmount,
			@SettlementAmount
			)

END
GO
