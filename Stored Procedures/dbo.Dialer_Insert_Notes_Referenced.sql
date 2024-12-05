SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/12/2010
-- Description:	Default some values for dialer call notes and insert a referenced record.
-- History: tag removed
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-11-12   Time: 11:10:49-05:00 
--  Updated in: /GSSI/Core/Database/8.3.0/StoredProcedures 
--  check for null values 
CREATE PROCEDURE [dbo].[Dialer_Insert_Notes_Referenced] 
	@UID   bigint output,
	@FileNumber   int,
	@Calltime   datetime = null,
	@UTCCallTime datetime = null,
	@UserName   varchar (10),
	@Action   varchar (6),
	@Result   varchar (6),
	@RefDialerInstance varchar(50) = null,
	@RefDialerCallKey varchar(20) = null,
	@Comment   text
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int

    EXEC @Err = Lib_Insert_notes 
					@UID OUTPUT,  
					@FileNumber,  
					null,  
					@Calltime,  
					@UserName,  
					@Action,  
					@Result,  
					@Comment,  
					null, 
					@UTCCallTime

	IF @Err <> 0
		RETURN @Err

	IF @RefDialerCallKey is not null AND @RefDialerInstance is not null
	BEGIN
		INSERT INTO [Notes_Referenced](NoteId, RefSource, RefKey)
		VALUES(@UID, @RefDialerInstance, @RefDialerCallKey)
		SET @Err = @@ERROR
		IF @Err <> 0
			RETURN @Err
	END
	
	RETURN @@ERROR
END
GO
