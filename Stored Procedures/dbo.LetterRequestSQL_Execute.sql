SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*LetterRequestSQL_Execute*/
Create Procedure [dbo].[LetterRequestSQL_Execute]
	@LetterID int,
	@LetterCode varchar(5),
	@RequestForDate smallDateTime,
	@UserID int,
	@Username varchar(10)

 /*
** Name:		LetterRequestSQL_Execute
** Function:		Inserts Dunning letters into LetterRequests and LetterRequestRecipient table
**			from the LetterRequestTemp table
**			Not used for other letter types such as PDC or PPA
** Used By		Latitude SQL Letter Requester
** Creation:		8/25/2004 mr
** Change History:	
** Change History:
**			
 */

AS

Declare @RequestBeginTime datetime

SET @RequestForDate = convert(datetime, @RequestForDate, 103)
SET @RequestBeginTime =  GetDate()

WAITFOR DELAY '000:00:01'   --To make sure no request has the same time as @RequestBeginTime

BEGIN TRAN

INSERT INTO LetterRequest
(
AccountID,
CustomerCode,
LetterID,
LetterCode,
DateRequested,
UserName,
CopyCustomer,
SaveImage,
DateCreated,
DateUpdated,
SubjDebtorID,
RecipientDebtorID,
RecipientDebtorSeq,
SenderID
)
SELECT 
	AccountID,
	Customer,
	@LetterID,
	@LetterCode,
	@RequestForDate, 
	@Username,
	CopyCustomer,
	SaveImage,
	GetDate(),
	GetDate(),
	SubjDebtorID,
	RecipientDebtorID,
	RecipientDebtorSeq,
	SenderID

FROM LetterRequestTemp with(nolock)
WHERE UserID = @UserID

IF @@Error = 0 BEGIN
	--Now add the recipient
	INSERT INTO LetterRequestRecipient(LetterRequestID,AccountID,DebtorID,Seq) 
	SELECT LetterRequestID,AccountID,RecipientDebtorID,RecipientDebtorSeq
	FROM LetterRequest with(nolock)
	WHERE DateCreated >= @RequestBeginTime 
	AND UserName = @UserName

	IF @@Error = 0 BEGIN
		COMMIT TRAN
		return 0
	END
END

--If this executes there was a error
if @@Error <> 0 begin
	rollback tran
	return @@Error
end

GO
