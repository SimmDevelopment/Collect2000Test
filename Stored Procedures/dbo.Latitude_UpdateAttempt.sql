SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/19/2007
-- Description:	Update all the statistics for an attempt
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.Latitude_UpdateAttempt.sql $
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Latitude_UpdateAttempt] 
	@FileNumber int, 
	@AttemptDate datetime,
	@NewQDate datetime,
	@Viewed bit,
	@Worked bit,
	@Contacted bit,
	@Desk varchar(10),
	@IsDialer bit
AS
BEGIN	
	DECLARE @DateOnly datetime
	DECLARE @TimeFrame int	
	DECLARE @Hour int
	DECLARE @Customer varchar(10)
	DECLARE @Err int
	DECLARE @MasterViewed datetime
	DECLARE @MasterWorked datetime
	DECLARE @MasterContacted datetime
	DECLARE @MasterQDateVal varchar(8)
	DECLARE @NewQDateVal varchar(8)
	DECLARE @MasterDesk varchar(10)

	SET NOCOUNT ON;

	-- Validate the @FileNumber parm
	SELECT TOP 1 
		@MasterViewed = Viewed, 
		@MasterWorked = Worked, 
		@MasterContacted = Contacted, 
		@MasterQDateVal = ISNULL(QDate,'00000000'), 
		@Customer = Customer,
		@MasterDesk = Desk 
	FROM Master 
	WHERE Number = ISNULL(@FileNumber, -1)

	-- if we didnt get a master record, then chances are this is the wrong database instance...
	IF @@ROWCOUNT = 0 
		RETURN -1

	-- Preprocess our data --------------------------------------------------------------
	-- Make sure we have an attempt date and save the attemptdate without the timestamp...
	SET @AttemptDate = ISNULL(@AttemptDate, GETDATE())
	SET @DateOnly = CAST(CONVERT(varchar, @AttemptDate, 107)as datetime)

	-- make sure the required fields are not null for processing...
	SET @Viewed = ISNULL(@Viewed, 0)
	SET @Worked = ISNULL(@Worked, 0)
	SET @Contacted = ISNULL(@Contacted, 0)
	SET @IsDialer = ISNULL(@IsDialer, 0)

	-- validate that @AttemptDate is greater than the current viewed date...
	IF (@Viewed = 1 AND DATEDIFF(day, ISNULL(@MasterViewed, '1991-01-01'), @DateOnly) > 0)
		SET @MasterViewed = @DateOnly

	-- validate that the attempt date is greater than current worked...
	IF (@Worked = 1 AND DATEDIFF(day, ISNULL(@MasterWorked, '1991-01-01'), @DateOnly) > 0) 
		SET @MasterWorked = @DateOnly
	
	-- validate that @AttemptDate is greater than the current contacted date...
	IF (@Contacted = 1 AND DATEDIFF(day, ISNULL(@MasterContacted, '1991-01-01'), @DateOnly) > 0)
		SET @MasterContacted = @DateOnly

	-- validate that the NewQDate is greater than the current QDate...
	-- if @NewQDate is null, then we should default to 1 day after Attempt
	SET @NewQDate = ISNULL(@NewQDate, DATEADD(day, 1, @AttemptDate))
	EXEC @NewQDateVal = MakeQDate @NewQDate
	IF @NewQDateVal > @MasterQDateVal 
		SET @MasterQDateVal = @NewQDateVal

	-- calculate the timeframe for account_work_stats
	-- @TimeFrame	1=morning, 2=afternoon, 3=evening, 4=weekend
	SET @Hour = DATEPART(hh, @AttemptDate)
	SET @TimeFrame = 
	CASE
		WHEN DATENAME(dw,@AttemptDate) in ('Saturday', 'Sunday') THEN 4
		WHEN @Hour < 12 THEN 1
		WHEN @Hour >= 18 THEN 3
		ELSE 2
	END

	-- Upate master record ---------------------------------------------------------
	UPDATE master 
	SET viewed = @MasterViewed, 
		worked = @MasterWorked, 
		contacted = @MasterContacted, 
		totalworked = ISNULL(totalworked, 0) + @Worked, 
		totalcontacted = ISNULL(totalcontacted, 0) + @Contacted, 
		totalviewed = ISNULL(totalviewed, 0) + @Viewed,
		qdate = @MasterQDateVal
	WHERE number = @FileNumber
	IF @@ERROR <> 0
		RETURN @@ERROR

	-- Update Account work stats ---------------------------------------------------------
    EXEC @Err = Account_WorkStats_Add @FileNumber, @IsDialer, @Worked, @Contacted, @TimeFrame
	IF @Err <> 0 
		RETURN @Err

	--Update CustomerStats ---------------------------------------------------------
	EXEC @Err = Latitude_UpdateCustomerAttempt @Customer, @Viewed, @Worked, @Contacted, @AttemptDate
	IF @Err <> 0 
		RETURN @Err

	--Update DeskStats only if this was not a automated dialer attempt -------------------
	IF @IsDialer = 0
	BEGIN
		-- if the desk was not passed in then get desk from master record.
		SET @Desk = ISNULL(@Desk, @MasterDesk)
		EXEC @Err = Latitude_UpdateDeskAttempt @Desk, @Viewed, @Worked, @Contacted, @AttemptDate
		IF @Err <> 0 
			RETURN @Err
	END

--	-- Update Daily_Account_Contacted ------------------------------------------------------------
--	IF (@Contacted = 1 AND DATEDIFF(day, GETDATE(), @AttemptDate) = 0)  - call disabled as per LAT-4237, now handled elsewhere
--	BEGIN
--		EXEC @Err = Daily_Account_Contacted_Add @FileNumber - NEVER do this here, done elsewhere (LAT-4237)
--		IF @Err <> 0 
--			RETURN @Err
--	END

	RETURN @@ERROR

END

GO
