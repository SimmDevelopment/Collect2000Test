SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*ALTER   PROCEDURE sp_Desk_Update*/
CREATE PROCEDURE [dbo].[sp_Desk_Update]
(
	@Code varchar(10),
	@Name varchar(30),
	@Priv varchar(100),
	@DeskType varchar(15),
	@Password varchar(8),
	@Branch varchar(5),
	@QueueRptDays int,
	@QueueRpt varchar(1),
	@WaitDays int,
	@MonthlyGoal money,
	@MonthlyCbrRequests int,
	@CbrRequests int,
	@CaseLimit int,
	@EnforceLimit bit,
	@DailyLimit int,
	@NewBizDays int,
	@MaxFollowup int,
	@CAlias varchar(30),
	@Phone varchar(12),
	@Extension varchar(6),
	@Email varchar(50),
	@MonthlyGoal2 varchar(20),
	@Special1 varchar(20),
	@Special2 varchar(20),
	@Special3 varchar(20),
	@VPassword varchar(10),
	@TeamID int,
	@PreventLinking BIT = NULL
)
AS

/*
** Name:		sp_Desk_Update
** Function:		This procedure will update a desk in Desk table
** 			using input parameters.
** Creation:		6/26/2002 jc
**			Used by class CDeskFactory. 
** Change History:
*/

    BEGIN TRAN
	
	UPDATE desk
		SET Name = @Name,
		Priv = @Priv,
		DeskType = @DeskType,
		password = @Password,
		Branch = @Branch,
		QueueRptDays = @QueueRptDays,
		QueueRpt = @QueueRpt,
		WaitDays = @WaitDays,
		MonthlyGoal = @MonthlyGoal,
		MonthlyCbrRequests = @MonthlyCbrRequests,
		CbrRequests = @CbrRequests,
		CaseLimit = @CaseLimit,
		EnforceLimit = @EnforceLimit,
		DailyLimit = @DailyLimit,
		NewBizDays = @NewBizDays,
		MaxFollowup = @MaxFollowup,
		CAlias = @CAlias,
		Phone = @Phone,
		Extension = @Extension,
		Email = @Email,
		MonthlyGoal2 = @MonthlyGoal2,
		Special1 = @Special1,
		Special2 = @Special2,
		Special3 = @Special3,
		VPassword = @VPassword,
		TeamID = @TeamID,
		PreventLinking = COALESCE(@PreventLinking, PreventLinking)
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Desk_Update: Cannot update Desk table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
