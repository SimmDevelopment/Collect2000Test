SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Phonecall_Attempts_Insert]
			@AccountID int,
			@DebtorID int,
			@MasterPhoneId int,
			@AttemptDate date,
			@loginName varchar(10),
			@ReturnID int Output
		AS 

		INSERT INTO Phonecall_Attempts(number, DebtorID, AttemptDate, MasterPhoneId, loginName)
		VALUES (@AccountID, @DebtorID, @AttemptDate, @MasterPhoneId, @loginName)

		IF @@Error = 0 BEGIN
			Select @ReturnID = SCOPE_IDENTITY()
			Return 0
		END

		Return @@Error
GO
