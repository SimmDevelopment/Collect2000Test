SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Check2ACH_InsertBatch]
@username varchar(10)
AS
INSERT INTO Check2ACH_Batch (CreatedBy)
VALUES (@username)

SELECT SCOPE_IDENTITY()




GO