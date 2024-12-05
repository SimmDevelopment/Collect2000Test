SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LMSE_InsertActionHistory]
@actionID uniqueidentifier,
@batchID uniqueidentifier,
@actionName varchar(200),
@userID int,
@appliedConfiguration xml,
@recordCount int
AS
BEGIN

	INSERT INTO [dbo].[LMSE_ActionHistory]([ActionID],[BatchID],[UserID],[RecordCount],[AppliedConfiguration],[Started],[ActionName])
	SELECT @actionID, @batchID, @userID, @recordCount, @appliedConfiguration,getdate(),@actionName
	
	SELECT SCOPE_IDENTITY()
	
END
GO
