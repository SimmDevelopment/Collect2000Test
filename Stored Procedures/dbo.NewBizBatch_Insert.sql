SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Object:  Stored Procedure dbo.NewBizBatch_Insert    Script Date: 2/5/2004 4:36:56 PM ******/
CREATE  PROCEDURE [dbo].[NewBizBatch_Insert]
	@FileName varchar(100),
	@UserName varchar(50),
	@ReturnID int output
AS

INSERT INTO ImportBatches(DateCreated, Filename, CreatedBy) Values(GetDate(), @FileName, @UserName)

IF (@@error=0)
	Select @ReturnID = SCOPE_IDENTITY()

Return @@Error


GO
