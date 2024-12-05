SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_FFAM_UpdateBatchNumber]
@receivedDate datetime,
@batchCode varchar(30)

AS

UPDATE master
SET id1 = @batchCode
WHERE customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 83) AND received = @receivedDate

SELECT number, account, name, received, id1
FROM master
WHERE id1 = @batchCode AND customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 83)


GO
