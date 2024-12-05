SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Check2ACH_InsertBatchDetail]
@abanumber varchar(50),
@accountnumber varchar(50),
@checknumber varchar(50),
@batch int,
@sequence int,
@username varchar(50)
AS
DELETE FROM check2ach_batchdetail where batch = @batch and sequence = @sequence

INSERT INTO Check2ACH_BatchDetail
(batch,sequence,abanumber,accountnumber,checknumber,insertedby)
VALUES
(@batch,@sequence,@abanumber,@accountnumber,@checknumber,@username)

SELECT SCOPE_IDENTITY()




GO
