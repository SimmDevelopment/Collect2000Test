SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/19/2007
-- Description:	Update all the statistics for a dialer made call
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Dialer_UpdateAttempt] 
	@FileNumber int, 
	@AttemptDate datetime,
	@NewQDate datetime,
	@Viewed bit,
	@Worked bit,
	@Contacted bit,
	@DialerCode varchar(10)
AS
BEGIN
	DECLARE @Err int
	DECLARE @IsDialer as bit

	SET @IsDialer = 1

	EXEC @Err = Latitude_UpdateAttempt 
		@FileNumber,  
		@AttemptDate,  
		@NewQDate,  
		@Viewed,  
		@Worked,  
		@Contacted,  
		@DialerCode,  
		@IsDialer

	IF @@ERROR <> 0 
		RETURN @@ERROR

	RETURN @Err
END
GO
