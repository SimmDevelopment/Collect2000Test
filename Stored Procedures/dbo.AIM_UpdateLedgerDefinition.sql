SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_UpdateLedgerDefinition    */







create       procedure [dbo].[AIM_UpdateLedgerDefinition]
	@ledgerDefinitionId int
	,@ledgerTypeId int
	,@portfolioId int
	,@recoursePeriodDays int
	,@condition varchar(50)
	,@calculationTypeId int
	,@calculationAmount float
AS

	update
		aim_ledgerdefinition
	set
		ledgertypeid = @ledgerTypeId 
		,portfolioId = @portfolioId
		,recoursePeriodDays = @recoursePeriodDays
		,condition = @condition
		,calculationTypeId = @calculationTypeId
		,calculationAmount = @calculationAmount
	where
		ledgerDefinitionId = @ledgerDefinitionId




GO
