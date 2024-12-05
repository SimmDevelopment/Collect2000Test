SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/12/2010
-- Description:	Insert Latitude notes and insert a referenced record. This replaces the [spNote_AddV5] sproc
-- History: tag removed
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2010-11-12   Time: 11:37:08-05:00 
--  Updated in: /GSSI/Core/Database/8.3.0/StoredProcedures 
--  change parm name 
CREATE PROCEDURE [dbo].[Latitude_Insert_Notes_Referenced] 
	@UID   bigint output,
	@FileNumber   int,
	@Created   datetime = null,
	@UserName   varchar (10),
	@Action   varchar (6),
	@Result   varchar (6),
	@ReferenceSource varchar(50) = null,
	@ReferenceKey varchar(20) = null, 
	@UpdateNewStatus bit,
	@IsPrivate bit,
	@Comment   text
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @UTCTime datetime
	DECLARE @WasNew bit

	/* add to the daily contacted list */
	-- EXEC Daily_Account_Contacted_Add  @FileNumber - call disabled as per LAT-4237, now handled elsewhere
	
	/* Added test for private and call to Lib_Insert_notes_private stored procedure
	04/25/2011  TJL  */
	
	IF @IsPrivate = 1
		BEGIN
		    EXEC @Err = Lib_Insert_notes_private 
					@UID OUTPUT,  
					@FileNumber,  
					null,  
					@Created,  
					@UserName,  
					@Action,  
					@Result,  
					@Comment,  
					null, 
					@UTCTime
		END
	ELSE
		BEGIN
		    EXEC @Err = Lib_Insert_notes 
					@UID OUTPUT,  
					@FileNumber,  
					null,  
					@Created,  
					@UserName,  
					@Action,  
					@Result,  
					@Comment,  
					null, 
					@UTCTime
		END

	IF @Err <> 0
		RETURN @Err

	IF (@UpdateNewStatus = 1)
		EXEC @Err = UpdateNewToActive @FileNumber, @WasNew OUTPUT

	IF @Err <> 0
		RETURN @Err

	IF @ReferenceSource is not null AND @ReferenceKey is not null
	BEGIN
		-- if refkey is numeric, then lets convert it and set refId (bigint) value.
		DECLARE @ReferenceId bigint
		DECLARE @MaxBigIntVal numeric(19)
		SET @MaxBigIntVal = 9223372036854775807
		IF @ReferenceKey not like '%[^0-9]%' AND LEN(@ReferenceKey) < 20 AND CAST(@ReferenceKey as numeric(19)) <= @MaxBigIntVal
			SET @ReferenceId = CAST(@ReferenceKey as bigint)
		ELSE
			SET @ReferenceId = null

		INSERT INTO [Notes_Referenced](NoteId, RefSource, RefKey, RefId)
		VALUES(@UID, @ReferenceSource, @ReferenceKey, @ReferenceId)
		SET @Err = @@ERROR
		IF @Err <> 0
			RETURN @Err
	END

	RETURN @Err
END
GO
