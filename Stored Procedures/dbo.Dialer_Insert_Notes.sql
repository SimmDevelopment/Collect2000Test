SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/19/2007
-- Description:	Default some values for dialer call notes.
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Dialer_Insert_Notes] 
	@FileNumber   int,
	@Calltime   datetime = null,
	@UserName   varchar (10),
	@Action   varchar (6),
	@Result   varchar (6),
	@Comment   text,
	@UtcCalltime datetime = null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @TimepartsDiff int
	DECLARE @UID bigint

	if @UtcCalltime is null
	BEGIN
		-- Calculate the UTC time for created. 
		SET @TimepartsDiff = DATEDIFF(ss, GETDATE(), GETUTCDATE())
		SET @UtcCalltime =   DATEADD (ss, @TimepartsDiff, @Calltime)
	END

	EXEC @Err = Lib_Insert_notes 
					@UID,  
					@FileNumber,  
					null,  
					@Calltime,  
					@UserName,  
					@Action,  
					@Result,  
					@Comment,  
					null, 
					@UtcCalltime
	IF @Err <> 0
		RETURN @Err

	RETURN @@ERROR
END
GO
