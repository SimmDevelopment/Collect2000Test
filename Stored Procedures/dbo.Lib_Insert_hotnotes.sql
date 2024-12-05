SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
[dbo].[Lib_Insert_hotnotes]
--808080,
100009,
'KEvin'
*/
CREATE procedure [dbo].[Lib_Insert_hotnotes]
(
      @NUMBER   int,
      @HOTNOTE   text)
as
BEGIN

	IF NOT EXISTS(SELECT [Number] FROM [dbo].[HotNotes] WITH (NOLOCK) WHERE [Number] = @NUMBER)BEGIN
		insert into [dbo].[HotNotes]
		(
			[NUMBER],
			[HOTNOTE]
		)
		values
		(
			  @NUMBER,
			  @HOTNOTE
		)
		
	END
	ELSE BEGIN
		DECLARE @ptrval binary(16)

		-- Find the pointer into the text column of the Hot Notes
		SELECT @ptrval = TEXTPTR([HotNote])
		FROM  [dbo].[HotNotes] WITH (NOLOCK)
		WHERE [dbo].[HotNotes].[Number] = @NUMBER

		-- Update the existing Hot Notes using the given value
		--UPDATETEXT [dbo].[HotNotes].[HotNote] @ptrval NULL 0 @HotNote
		UPDATETEXT [dbo].[HotNotes].[HotNote] @ptrval NULL 0 @HotNote
	END
END

GO
