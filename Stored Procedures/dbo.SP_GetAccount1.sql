SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SP_GetAccount1]
	@Number int

 AS

	SELECT * From master
	WHERE number = @number
GO
