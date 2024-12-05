SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 11/19/2007
-- Description:	Update the CustomerStats
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: jspindler   Date: 2009-05-21   Time: 16:08:06-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
-- =============================================
CREATE PROCEDURE [dbo].[Latitude_UpdateCustomerAttempt] 
	@Customer varchar(10), 
	@Viewed bit,
	@Worked bit,
	@Contacted bit,
	@AttemptDate datetime
AS
BEGIN
	Declare @SysMonth tinyint
	Declare @SysYear smallint
	SET NOCOUNT ON;

	SET @AttemptDate = CAST(CONVERT(varchar, ISNULL(@AttemptDate, GETDATE()), 107)as datetime)

	--Update CustomerStats 
	UPDATE CustomerStats 
	Set Contacted = Contacted + @Contacted,  
		Touched = Touched + @Viewed,  
		Worked = Worked + @Worked 
	WHERE Customer = @Customer  
		AND TheDate = @AttemptDate

	-- If there were no rows updated, then insert a record...
	IF @@RowCount = 0 
	BEGIN
		SELECT TOP 1 @SysMonth = CurrentMonth, @SysYear = CurrentYear  
		FROM ControlFile
		If @@Error <> 0	 
			RETURN @@Error

		INSERT INTO CustomerStats( 
			Customer,  
			TheDate,  
			Touched,  
			Worked,  
			Contacted,  
			Collections,  
			Fees,  
			NewItems,  
			NewDollars,  
			SystemMonth,  
			SystemYear)
		VALUES( 
			@Customer,  
			@AttemptDate,  
			@Viewed,  
			@Worked,  
			@Contacted,  
			0,  
			0,  
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
