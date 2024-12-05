SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[spHotNotes_Update] @Number INTEGER, @HotNote TEXT
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

IF EXISTS (SELECT * FROM [dbo].[HotNotes] WITH (ROWLOCK, XLOCK) WHERE [Number] = @Number)
	IF @HotNote IS NULL OR DATALENGTH(@HotNote) = 0
		DELETE FROM [dbo].[HotNotes]
		WHERE [Number] = @Number;
	ELSE
		UPDATE [dbo].[HotNotes]
		SET [HotNote] = @HotNote
		WHERE [Number] = @Number;
ELSE
	INSERT INTO [dbo].[HotNotes] ([Number], [HotNote])
	VALUES (@Number, @HotNote);

COMMIT TRANSACTION;

RETURN 0;

GO
