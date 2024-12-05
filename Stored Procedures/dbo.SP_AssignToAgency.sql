SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_AssignToAgency] 
	@Number int,
	@AgcyCode varchar (5),
	@Amt money,
	@Level tinyint,
	@RtnCode int output
 AS

	SELECT Number from AgencyPlacements where number = @Number and AgencyCode = @AgcyCode /*Test to see if Agency has had account before */
	
	IF (@@rowcount <> 0) BEGIN /*This means that the agency you are trying to assign the account to has already had the account before */
		set @RtnCode = -1
	END
	ELSE BEGIN
		BEGIN TRAN
		
		INSERT INTO AgencyPlacements (Number, AgencyCode, AmtPlaced, DatePlaced, PlacementLevel)
		VALUES(@Number, @AgcyCode, @Amt, getdate(), @Level)
	
		Update Master set agencyflag = 2, AgencyCode = @AgcyCode where number = @number
				
		IF (@@error = 0) BEGIN
			COMMIT TRAN
			SET @RtnCode = 1
		END
		ELSE BEGIN
			ROLLBACK TRAN
			SET @RtnCode = 0
		END

	END



GO
