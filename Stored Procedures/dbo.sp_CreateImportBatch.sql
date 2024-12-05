SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_CreateImportBatch]
	@CreatedDate datetime,
	@BatchNumber int output
 AS

INSERT INTO ImportBatches(DateCreated) Values(@CreatedDate)

IF (@@error=0)
	Select @BatchNumber = SCOPE_IDENTITY()

GO
