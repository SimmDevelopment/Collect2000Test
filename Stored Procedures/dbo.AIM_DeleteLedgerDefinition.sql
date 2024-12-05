SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Object:  Stored Procedure dbo.AIM_DeleteLedgerDefinition    */

create       procedure [dbo].[AIM_DeleteLedgerDefinition]
	@ledgerDefinitionId int
AS

	delete
		aim_ledgerdefinition
	where
		ledgerDefinitionId = @ledgerDefinitionId




GO
