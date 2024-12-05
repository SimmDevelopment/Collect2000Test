SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Latitude_Update_Master_StatusNewToActive] 
		@FileNumber int, 
		@UserName varchar(50),
		@FirstWorkDate datetime,
		@WasNew bit OUTPUT
	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @Err int

		-- Default a few variables...
		SET @WasNew = 0
		SET @FirstWorkDate = CAST(CONVERT(varchar, ISNULL(@FirstWorkDate,GETDATE()), 107)as datetime)

		UPDATE master 
		SET Status = 'ACT', Complete1 = ISNULL(Complete1,@FirstWorkDate)  
		WHERE number = @FileNumber AND status = 'NEW'

		IF (@@ROWCOUNT > 0) 
		BEGIN
			PRINT 'Latitude_UpdateNewToActiveStatus updated ' + CONVERT(varchar, @@ROWCOUNT) + ' record for filenumber: ' + CONVERT(varchar, @FileNumber)
			SET @WasNew = 1
			EXEC @Err = Latitude_Insert_StatusHistory @FileNumber, @UserName, 'NEW', 'ACT'
			IF @Err <> 0 
				RETURN @Err 
		END

		RETURN @@ERROR
	END
GO
