SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[SP_CreateFile]
AS
INSERT INTO Files (DeskID) VALUES(Null) 

return SCOPE_IDENTITY()

GO
