SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Unknown
-- Create date: Unknown
-- Description:	Library procedure for inserting private notes.
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE  procedure [dbo].[Lib_Insert_notes_private]
(
      @UID   bigint output,
      @NUMBER   int,
      @CTL   varchar (3),
      @CREATED   datetime,
      @USER0   varchar (10),
      @ACTION   varchar (6),
      @RESULT   varchar (6),
      @COMMENT   text,
      @SEQ   int,
	  @UTCCREATED datetime = null
)
as
begin
	DECLARE @HoursDiff int

	if @CREATED is null
	BEGIN
		SET @CREATED=getdate()
	END	

	if @UTCCREATED is null
	BEGIN
		---- Calculate the UTC time for created. 
		--SET @HoursDiff = DATEDIFF(hh, GETDATE(), GETUTCDATE())
		--SET @UTCCREATED = DATEADD(hh, @HoursDiff, @CREATED)
		
		-- The above code does not always work correctly
		-- For instance, if by some chance the difference of the server time and client time
		-- is just less than an hour because one is off by a few seconds.
		-- Another problem is that this logic assumes that the created date sent is instantaneous.
		-- Changed this to use server time
		-- Same as Lib_Insert_notes 
		-- 4/25/2011  TJL
		
		SET @UTCCREATED = getutcdate()
	END

	insert into dbo.notes
	(
		  NUMBER,
		  CTL,
		  CREATED,
		  USER0,
		  ACTION,
		  RESULT,
		  COMMENT,
		  SEQ,
		  UTCCREATED,
		  IsPrivate
	)
	values
	(
		  @NUMBER,
		  @CTL,
		  @CREATED,
		  @USER0,
		  @ACTION,
		  @RESULT,
		  @COMMENT,
		  @SEQ,
		  @UTCCREATED,
		  1
	)
	SELECT @UID = SCOPE_IDENTITY()

	RETURN @@ERROR
end
GO
