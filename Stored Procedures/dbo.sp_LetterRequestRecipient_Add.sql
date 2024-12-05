SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_LetterRequestRecipient_Add*/
CREATE  Procedure [dbo].[sp_LetterRequestRecipient_Add]
	@LetterRequestRecipientID int OUTPUT,
	@LetterRequestID int,
	@AccountID int,
	@Seq int,
	@DebtorID int,
	@CustomerCode varchar(7),
	@AttorneyID int,
	@DebtorAttorney bit
AS
-- Name:		sp_LetterRequestRecipient_Add
-- Function:		This procedure will add a letter request recipients using input parameters.
-- Creation:		6/18/2003 
--			Used by Letter Console 
-- Change History:
--			10/13/2003 jc Changed input parm @AttorneyCode varchar(5) to @AttorneyID int

	INSERT INTO LetterRequestRecipient
	(
	LetterRequestID,
	AccountID,
	Seq,
	DebtorID,
	CustomerCode,
	AttorneyID,
	DebtorAttorney
	)
	VALUES
	(
	@LetterRequestID,
	@AccountID,
	@Seq,
	@DebtorID,
	@CustomerCode,
	@AttorneyID,
	@DebtorAttorney
	)

	SET @LetterRequestRecipientID = SCOPE_IDENTITY()


GO
