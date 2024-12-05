SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 09/25/2006
-- Description:	This is the StoredProc that will set the fusion config for the key specified
-- =============================================
CREATE PROCEDURE [dbo].[fusion_SetConfig]
	@name varchar(255),
	@config text
AS
BEGIN

	SET NOCOUNT ON;

	--see if its an update or an insert
	if exists (select * from FusionConfig where Name=@name)
		BEGIN
			--Perform update
		update FusionConfig set Config=@config where Name=@name
		END
	ELSE
		BEGIN
			--perform insert
			Insert into FusionConfig([Name],[Config])
			Values(@name,@config)
		END
END
GO
