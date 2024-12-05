SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*AcctMoverJobItems_Insert*/
CREATE PROCEDURE [dbo].[AcctMoverJobItems_Insert]
	@JobID int,
	@Number int,	-- will be either a master.number or master.link depending on @IsLink parameter
	@IsLink bit,
	@NewDesk varchar(10)

AS

If @IsLink = 0
	INSERT INTO AcctMoverJob_Items(JobID, AccountID, OldDesk, NewDesk)
	Select @JobID, @Number, Desk, @NewDesk from master where number = @Number

Else
	INSERT INTO AcctMoverJob_Items(JobID, AccountID, OldDesk, NewDesk)
	Select @JobID, Number, Desk, @NewDesk from master where link = @Number


Return @@Error
GO
