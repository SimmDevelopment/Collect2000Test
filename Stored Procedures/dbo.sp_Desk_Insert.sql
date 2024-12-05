SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*ALTER   PROCEDURE sp_Desk_Insert*/
CREATE  PROCEDURE [dbo].[sp_Desk_Insert]
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
	@PreventLinking BIT = 0
)
AS

/*
** Name:		sp_Desk_Insert
** Function:		This procedure will insert a new desk in Desk table
** 			using input parameters.
** Creation:		6/26/2002 jc
**			Used by class CDeskFactory. 
** Change History:
*/

    BEGIN TRAN
	
	INSERT INTO Desk 
		(code,
		Name,
		Priv,
		DeskType,
		password,
		Branch,
		QueueRptDays,
		QueueRpt,
		WaitDays,
		MonthlyGoal,
		MonthlyCbrRequests,
		CbrRequests,
		CaseLimit,
		EnforceLimit,
		DailyLimit,
		NewBizDays,
		MaxFollowup,
		CAlias,
		Phone,
		Extension,
		Email,
		MonthlyGoal2,
		Special1,
		Special2,
		Special3,
		VPassword,
		TeamID,
		PreventLinking)
	VALUES(
		@Code,
		@Name,
		@Priv,
		@DeskType,
		@Password,
		@Branch,
		@QueueRptDays,
		@QueueRpt,
		@WaitDays,
		@MonthlyGoal,
		@MonthlyCbrRequests,
		@CbrRequests,
		@CaseLimit,
		@EnforceLimit,
		@DailyLimit,
		@NewBizDays,
		@MaxFollowup,
		@CAlias,
		@Phone,
		@Extension,
		@Email,
		@MonthlyGoal2,
		@Special1,
		@Special2,
		@Special3,
		@VPassword,
		@TeamID,
		@PreventLinking)
    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Desk_Insert: Cannot insert into Desk table ')
        ROLLBACK TRAN
        RETURN(1)
    END

    COMMIT TRAN
GO
