SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/****** Object:  Stored Procedure dbo.ImportNBHotNotes_Insert    Script Date: 2/5/2004 4:36:56 PM ******/
CREATE PROCEDURE [dbo].[ImportNBHotNotes_Insert] 
	@Number int,
	@HotNote text
AS

INSERT INTO ImportNBHotNotes (Number, HotNote)
VALUES (@Number, @HotNote)

Return @@Error
GO
