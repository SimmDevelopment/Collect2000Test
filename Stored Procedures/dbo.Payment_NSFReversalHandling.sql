SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Payment_NSFReversalHandling]
@FileNumber int,
@ReverseOfUID int,
@PostDateType varchar(5),
@ErrorBlock varchar(30) Output
AS

/*
** REASON FOR LIVING: Make changes to status and Queue information on any account that is effected by a reversal.
**			If this reversed payment is part of an arrangement.
** 				set all to same status, qlevel to 875 on followers, qlevel, shouldqueue, and qdate on drivers.
**			Otherwise  just do the normal stuff.
** Header: tag removed
** Workfile: tag removed
** History: tag removed
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:58:52-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  moved logic out to account_nsfhandling 
--  
--  ****************** Version 4 ****************** 
--  User: mdevlin   Date: 2009-11-03   Time: 16:18:23-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Integrated nsf functionality from payment reversals into payment vendor 
--  decline process (payment not entered because cc or pdc declined). 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2009-07-24   Time: 15:49:40-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Removed useless argument 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2009-07-24   Time: 12:11:10-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
*/
DECLARE @Err int 
DECLARE @PostDateId int
DECLARE @POSTDATE_PDC varchar(3)
DECLARE @POSTDATE_DEBTORCREDITCARD varchar(3)
DECLARE @POSTDATE_NOT varchar(3)
DECLARE @INVALID_UID int

SET @POSTDATE_PDC = 'PDC'
SET @POSTDATE_DEBTORCREDITCARD = 'PCC'
SET @POSTDATE_NOT = 'NOT'
SET @INVALID_UID = -1

-- Get any pcc or pdc arrangement information
SET @PostDateId = @ReverseOfUID;
IF @ReverseOfUID IS NULL
BEGIN
	IF @PostDateType = @POSTDATE_DEBTORCREDITCARD
	BEGIN
		SELECT @PostDateId = ISNULL(PostDateUID, @INVALID_UID) FROM PayHistory WHERE uid = @ReverseOfUID
		IF @PostDateId IS NOT null AND @FileNumber IS NULL
			SELECT @FileNumber = number FROM DebtorCreditCards WHERE ID = @PostDateId
	END
	ELSE
	BEGIN
		IF @PostDateType = @POSTDATE_PDC
		BEGIN
			SELECT @PostDateId = PostDateUID FROM PayHistory WHERE uid = @ReverseOfUID
			IF @PostDateId IS NOT null AND @FileNumber IS NULL
				SELECT @FileNumber = number FROM PDC WHERE UID = @PostDateId
		END
	END

	-- If there was no pcc/pdc arangement then
	IF @FileNumber is null
	BEGIN
		PRINT 'No current arrangement for: ' + CAST(@FileNumber AS varchar(10))
		BEGIN
			SELECT @FileNumber = @FileNumber, @PostDateType = @POSTDATE_NOT, @PostDateId = @INVALID_UID
		END
	END
END

EXEC @Err = Account_NSFHandling @FileNumber, @PostDateId, @PostDateType, @ErrorBlock = @ErrorBlock OUTPUT

RETURN @Err
GO
