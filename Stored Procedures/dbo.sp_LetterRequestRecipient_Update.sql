SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LetterRequestRecipient_Update*/
CREATE Procedure [dbo].[sp_LetterRequestRecipient_Update]
	@LetterRequestRecipientID int,
	@LetterRequestID int,
	@AccountID int,
	@Seq int,
	@DebtorID int,
	@CustomerCode varchar(7),
	@AttorneyID int,
	@DebtorAttorney bit
AS
-- Name:		sp_LetterRequestRecipient_Update
-- Function:		This procedure will update a letter request recipient using input parameters.
-- Creation:		6/18/2003 
--			Used by Letter Console 
-- Change History:
--			10/13/2003 jc Changed input parm @AttorneyCode varchar(5) to @AttorneyID int

	UPDATE LetterRequestRecipient
	SET
	LetterRequestID = @LetterRequestID,
	AccountID = @AccountID,
	Seq = @Seq,
	DebtorID = @DebtorID,
	CustomerCode = @CustomerCode,
	AttorneyID = @AttorneyID,
	DebtorAttorney = @DebtorAttorney
	WHERE LetterRequestRecipientID = @LetterRequestRecipientID
GO
