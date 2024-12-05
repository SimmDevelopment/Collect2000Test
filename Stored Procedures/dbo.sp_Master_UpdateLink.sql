SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Master_UpdateLink*/
CREATE Procedure [dbo].[sp_Master_UpdateLink]
	@Number int,
	@Link int
AS

update master set link = @link where number = @Number

GO
