SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ImportNBBigNotes_Insert] 
	@Number int,
	@BigNote text
AS

INSERT INTO ImportNBBigNotes (Number, BigNote)
VALUES (@Number, @BigNote)

Return @@Error
GO
