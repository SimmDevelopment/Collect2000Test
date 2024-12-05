SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spHotNotes_Select*/
CREATE PROCEDURE [dbo].[spHotNotes_Select]
	@AccountID int
AS


Select * from HotNotes with(nolock) where number = @AccountID

Return @@Error
GO
