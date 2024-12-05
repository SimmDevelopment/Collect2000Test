SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   procedure [dbo].[AIM_InsertPortfolio]
	@portfolioTypeId int,
	@code varchar(50),
	@treepath varchar(500)
AS

declare @pID int

	insert into 
	AIM_Portfolio
	(
		portfolioTypeId,
		code,
		treepath
	)
	values
	(
		@portfolioTypeId,
		@code,
		@treepath
	)
	select @pID =  @@identity

DELETE FROM AIM_TempPurchaseAccounts
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (4,0,7,1,null,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (4,0,11,1,null,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (4,0,13,1,null,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (5,0,null,1,null,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (3,null,null,2,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (11,null,null,2,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (10,null,null,2,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (12,null,null,2,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (7,null,null,2,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (8,null,null,2,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (9,null,null,1,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (6,null,null,1,0,@pID)
INSERT INTO AIM_LedgerDefinition (LedgerTypeId,RecoursePeriodDays,Condition,CalculationTypeId,CalculationAmount,PortfolioId)   VALUES (14,null,null,1,0,@pID)

SELECT @pID




GO
