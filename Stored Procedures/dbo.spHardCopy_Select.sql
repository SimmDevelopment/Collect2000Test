SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spHardCopy_Select*/
CREATE Procedure [dbo].[spHardCopy_Select]
	@AccountID int
AS
Set Nocount On

SELECT * from HardCopy with(nolock) 
WHERE number = @AccountID

Return @@Error
GO
