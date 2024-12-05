SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*spDeskChange*/
CREATE    procedure [dbo].[spDeskChange]
	@AccountID int,
	@NewDesk varchar(10),
	@Qlevel varchar (3),
	@Qdate varchar (8),
	@NewBranch varchar(10) Output,
	@LoginName VARCHAR(10) = NULL
AS

 /*
**Name		:spDeskChange
**Function	:Updates the master.Desk, master.Branch, master.QDate and master.QLevel
**Creation	:6/25/2003 mr
**Used by 	:Latitude.frmAccount
**Change History:2/29/2004 mr If @NewBranch parameter is null we get it from Desk table
**		:	      otherwise use the value supplied. 
**		:5/26/2004 mr Added lines to move PDCs and Promises to the new desk (v4.0.26) 
**		:8/24/2006 jbs Added @LoginName parameter, used to populate DeskChangeHistory table
**		:8/24:2006 jbs Added lines to move PCCs to the new desk (v.4.37)
*/

DECLARE @OldDesk VARCHAR(10);
DECLARE @OldBranch VARCHAR(5);
DECLARE @OldQLevel VARCHAR(3);
DECLARE @OldQDate VARCHAR(8);

If @NewBranch is null 
	Select @NewBranch = Branch from desk where Code = @NewDesk

BEGIN TRANSACTION;

SELECT @OldDesk = desk,
	@OldBranch = branch,
	@OldQLevel = qlevel,
	@OldQDate = qdate
FROM master WITH (ROWLOCK)
WHERE number = @AccountID;

UPDATE master SET Qlevel=@Qlevel,Qdate=@qdate,Desk=@NewDesk,Branch=@NewBranch where number =@AccountID

IF @@ERROR <> 0 BEGIN
	ROLLBACK TRANSACTION;
	RETURN -1;
END;

IF @LoginName IS NULL
	SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

INSERT INTO dbo.DeskChangeHistory (Number, JobNumber, OldDesk, NewDesk, OldQLevel, NewQLevel, OldQDate, NewQDate, OldBranch, NewBranch, [User], DMDateStamp)
VALUES (@AccountID, '', @OldDesk, @NewDesk, @OldQLevel, @QLevel, @OldQDate, @QDate, @OldBranch, @NewBranch, @LoginName, GETDATE());

IF @@ERROR <> 0 BEGIN
	ROLLBACK TRANSACTION;
	RETURN -1;
END;

UPDATE PDC Set Desk = @NewDesk Where number = @AccountID

IF @@ERROR <> 0 BEGIN
	ROLLBACK TRANSACTION;
	RETURN -1;
END;

UPDATE Promises Set Desk = @NewDesk Where AcctID = @AccountID

IF @@ERROR <> 0 BEGIN
	ROLLBACK TRANSACTION;
	RETURN -1;
END;

COMMIT TRANSACTION;

RETURN 0;




GO
