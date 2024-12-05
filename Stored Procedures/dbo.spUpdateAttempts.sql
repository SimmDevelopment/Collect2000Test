SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spUpdateAttempts*/
CREATE PROCEDURE [dbo].[spUpdateAttempts]
	@UserLogin varchar(10),
	@TheDate datetime

AS 


Declare @TotalAttempts smallint
Declare	@SysMonth tinyint
Declare @SysYear smallint


Select @SysMonth = CurrentMonth, @SysYear = CurrentYear from ControlFile


SELECT @TotalAttempts = Attempts from DeskStats Where Desk = @UserLogin and TheDate = @TheDate

IF @@RowCount = 0 

	INSERT Into DeskStats(Desk, TheDate, Worked, Contacted, Touched, Attempts, Collections, Fees, SystemMonth, SystemYear)
	VALUES(@UserLogin, @TheDate, 0, 0, 0, 1, 0, 0, @SysMonth, @SysYear)

ELSE BEGIN

	IF @TotalAttempts is null SET @TotalAttempts = 0
	
	UPDATE DeskStats Set Attempts = @TotalAttempts + 1 Where Desk = @UserLogin and TheDate = @TheDate 

END


Return 0
GO
