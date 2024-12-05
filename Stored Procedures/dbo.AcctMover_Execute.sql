SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*AcctMover_Execute*/
CREATE PROCEDURE [dbo].[AcctMover_Execute]
	@JobID int,
	@Undo bit,
	@User varchar(10),
	@JobDefXML varchar(4000),
	@NumberMoved int output

 /*
**Name		:AcctMover_Execute
**Function	:If @Undo=0 the Items in AcctMoverJob_Items of this @JobID are Desk changed to the NewDesk value.
**		:If @Undo=1 the items in are Desk changed back to their original Desk.
**Creation	:Apr 26, 2004 mr
**Used by 	:GSSMover.dll
**Change History:7/8/2004 mr fixes all statements that update PDCs and Promises which did not have Where Clauses, caused some Promises.Desks and PDC.Desks to be set to NULL.
*/

AS

Declare @CompletedDate SmallDateTime
Declare @Err int

SELECT @CompletedDate = DateCompleted from AcctMoverJob Where JobID = @JobID 
IF @Undo = 0 and (Not @CompletedDate is null)
	Return -1
IF @Undo = 1 and @CompletedDate is null
	Return -2


BEGIN TRAN
IF @Undo = 0 BEGIN

	UPDATE Master SET Desk = (SELECT NewDesk from AcctMoverJob_Items 
				  WHERE JobID = @JobID and AccountID = Master.number)
	WHERE number in (SELECT AccountID from AcctMoverJob_Items WHERE JobID = @JobID)

	SELECT @Err=@@Error, @NumberMoved=@@Rowcount
	IF @Err <> 0 GOTO ErrorHandler

	--Move PDCs
	UPDATE PDC Set Desk = (SELECT NewDesk from AcctMoverJob_Items
			       WHERE JobID = @JobID and AccountID = PDC.number)
	WHERE number in (Select AccountID from AcctMoverJob_Items where JobID = @JobID)


	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler

	--Move Promises
	UPDATE Promises Set Desk = (SELECT NewDesk from AcctMoverJob_Items
				    WHERE JobID = @JobID and AccountID = Promises.AcctID)
	WHERE AcctID in (Select AccountID from AcctMoverJob_Items where JobID = @JobID)


	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler

	--Make a Note
	INSERT INTO Notes(Number, Created, User0, Action, Result, Comment)
	SELECT AccountID, GetDate(), @User, 'DESK', 'CHNG', 'Desk Changed from ' + OldDesk + ' to ' + NewDesk
	FROM AcctMoverJob_Items WHERE JobID = @JobID

	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler

END
ELSE BEGIN
	--move the desk back only if it's still assigned to the New Desk
	UPDATE Master Set Desk = (SELECT OldDesk from AcctMoverJob_Items 
				  WHERE JobID = @JobID and AccountID = Master.number)
	WHERE number in (Select AccountID from AcctMoverJob_Items WHERE JobID = @JobID
				  AND NewDesk = master.Desk)

	SELECT @Err=@@Error, @NumberMoved=@@Rowcount
	IF @Err <> 0 GOTO ErrorHandler

	--Move PDCs
	UPDATE PDC Set Desk = (SELECT OldDesk from AcctMoverJob_Items
			       WHERE JobID = @JobID and AccountID = PDC.number)
	WHERE number in (Select AccountID from AcctMoverJob_Items where JobID = @JobID)


	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler


	--Move Promises
	UPDATE Promises Set Desk = (SELECT OldDesk from AcctMoverJob_Items
				    WHERE JobID = @JobID and AccountID = Promises.AcctID)
	WHERE AcctID in (Select AccountID from AcctMoverJob_Items where JobID = @JobID)


	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler

	INSERT INTO Notes(Number, Created, User0, Action, Result, Comment)
	SELECT AccountID, GetDate(), @User, 'DESK', 'CHNG', 'Desk Changed from ' + NewDesk + ' to ' + OldDesk
	FROM AcctMoverJob_Items WHERE JobID = @JobID

	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler

END

--Set the Branch
UPDATE Master Set Branch = (Select Branch from Desk where Code = Master.Desk)
WHERE number in (Select AccountID from AcctMoverJob_Items where JobID = @JobID)

SELECT @Err=@@Error
IF @Err <> 0 GOTO ErrorHandler

--Update or the AcctMoverJob record
IF @Undo = 0 BEGIN

	--Set the DateCompleted, NumberMoved and JobDefXML
	UPDATE AcctMoverJob Set DateCompleted = GetDate(), NumberMoved = @NumberMoved, JobDefXML = @JobDefXML
	WHERE JobID = @JobID

	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler	

END
ELSE BEGIN

	--Set the DateUndone and UndoneUser
	UPDATE AcctMoverJob Set DateUndone = GetDate(), UndoneBy = @User
	WHERE JobID = @JobID 

	SELECT @Err=@@Error
	IF @Err <> 0 GOTO ErrorHandler	

END

COMMIT TRAN
Return 0

ErrorHandler:
	ROLLBACK TRAN
	Return @Err
GO
