SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** CREATE PROCEDURE sp_NewX1    Script Date: 10/13/2002 8:30:34 PM ******/
CREATE PROCEDURE [dbo].[sp_NewX1]

AS
Declare @X smallint

SELECT @X = X1 FROM ControlFile
	IF @X is Null
		SET @X = 1
	IF @X = 900
		UPDATE ControlFile SET X1 = 1
	ELSE
		UPDATE ControlFile SET X1 = @X +1
Return @X
GO
