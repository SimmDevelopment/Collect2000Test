SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Michael D. Devlin
-- Create date: 12/12/2007
-- Description:	Insert records into ArchiveHistory
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:05-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Archive_Insert_ArchiveHistory] 
	@LatitudeUser varchar(255), 
	@ArchiveAction tinyint,
	@Comment text
AS
BEGIN
	INSERT INTO ArchiveHistory
	(
		CreatedBy,
		ArchiveAction,
		Comment
	)
	VALUES
	(
		ISNULL(@LatitudeUser, suser_sname()), 
		ISNULL(@ArchiveAction, 0),
		@Comment
	)
	RETURN @@ERROR
END
GO
