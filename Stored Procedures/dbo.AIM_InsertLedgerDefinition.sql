SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_InsertLedgerDefinition    */







create       procedure [dbo].[AIM_InsertLedgerDefinition]
	@ledgerTypeId int
	,@portfolioId int
	,@recoursePeriodDays int
	,@condition varchar(50)
	,@calculationTypeId int
	,@calculationAmount float
AS

	insert into
		aim_ledgerdefinition
	(
		ledgertypeid
		,portfolioId
		,recoursePeriodDays
		,condition 
		,calculationTypeId 
		,calculationAmount 
	)
	values
	(
		@ledgerTypeId 
		,@portfolioId
		,@recoursePeriodDays
		,@condition
		,@calculationTypeId
		,@calculationAmount
	)





GO
