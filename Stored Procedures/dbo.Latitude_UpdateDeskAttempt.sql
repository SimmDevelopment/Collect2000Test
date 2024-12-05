SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Latitude_UpdateDeskAttempt] 
		@Desk varchar(10), 
		@Viewed bit,
		@Worked bit,
		@Contacted bit,
		@AttemptDate datetime
	AS
	BEGIN
		Declare @SysMonth tinyint
		Declare @SysYear smallint
		SET NOCOUNT ON;

		-- If we were not passed a desk value, then dont update the deskstats table...
		IF @Desk is null
			RETURN 0

		-- If attemptdate is null then use current date. 
		-- Also remove any time portion of the @AttemptDate parm...
		SET @AttemptDate = CAST(CONVERT(varchar, ISNULL(@AttemptDate, GETDATE()), 107)as datetime)

		--Update CustomerStats 
		UPDATE DeskStats 
		SET Attempts = Attempts + 1, 
			Contacted = Contacted + @Contacted, 
			Touched = Touched + @Viewed, 
			Worked = Worked + @Worked 
		WHERE Desk = @Desk 
			AND TheDate = @AttemptDate

		-- If there were no rows updated, then insert a record...
		IF @@RowCount = 0 
		BEGIN
			SELECT TOP 1 @SysMonth = CurrentMonth, @SysYear = CurrentYear 
			FROM ControlFile
			If @@Error <> 0	
				RETURN @@Error

			INSERT INTO DeskStats(
				Desk, 
				TheDate, 
				Touched, 
				Worked, 
				Contacted, 
				Attempts, 
				Collections, 
				Fees, 
				SystemMonth, 
				SystemYear)
			VALUES(
				@Desk,  
				@AttemptDate,  
				@Viewed,  
				@Worked,  
				@Contacted,  
				1,  
				0,  
				0,  
				@SysMonth,  
				@SysYear)
		
			IF @@Error <> 0 
				RETURN @@Error
		END
		RETURN @@Error
	END
GO
