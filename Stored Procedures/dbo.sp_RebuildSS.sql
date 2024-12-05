SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_RebuildSS*/
CREATE  PROCEDURE [dbo].[sp_RebuildSS]
	@Cust varchar(7)
 AS
Declare @Results int

SET NOCOUNT ON

EXEC [dbo].[RebuildStairStep] @Customer = @Cust;
/*
DELETE FROM StairStep WHERE Customer = @Cust
IF @@Error <> 0 
	Return @@Error
EXEC @Results = sp_RebuildSS1 @Cust
IF @Results <> 0
	Return @Results
EXEC @Results = sp_RebuildSS2 @Cust
IF @Results <> 0
	Return @Results
EXEC @Results = sp_RebuildSS3 @Cust
IF @Results <> 0
	Return @Results
IF @@Error = 0
	Return 0
*/

GO
