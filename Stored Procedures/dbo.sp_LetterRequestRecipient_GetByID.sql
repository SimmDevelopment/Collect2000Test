SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_LetterRequestRecipient_GetByID*/
CREATE Procedure [dbo].[sp_LetterRequestRecipient_GetByID]
	@LetterRequestRecipientID INT
AS
-- Name:		sp_LetterRequestRecipient_GetByID
-- Function:		This procedure will retrieve letter request recipients by LetterRequestRecipientID
--			using input parameter @LetterRequestRecipientID.
-- Creation:		6/18/2003 
--			Used by Letter Console 
-- Change History:
--			10/13/2003 jc Removed join to restrictions table. The attorney info contained
--			in the restrictions table is no longer valid. Debtor attorney's are 
--			currently not supported as letter recipients.
--			10/13/2003 jc changed join to attorney table from AttorneyCode to AttorneyID

	SELECT [LRR].[LetterRequestRecipientID],
	[LRR].[LetterRequestID],
	[LRR].[AccountID],
	[LRR].[Seq],
	[LRR].[DebtorID],
	[LRR].[CustomerCode],
	[LRR].[DebtorAttorney],
	[LRR].[DateCreated],
	[LRR].[DateUpdated],
	[LRR].[AttorneyID],
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltName, '')
		WHEN A.Name IS NOT NULL THEN A.Name
		WHEN C.Name IS NOT NULL THEN C.Name
		WHEN D.Name IS NOT NULL THEN D.Name
		ELSE M.Name
	END AS RecipientName,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltStreet1, '')
		WHEN A.Name IS NOT NULL THEN A.Street1
		WHEN C.Name IS NOT NULL THEN C.Street1
		WHEN D.Name IS NOT NULL THEN D.Street1
		ELSE M.Street1
	END AS Street1,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltStreet2, '')
		WHEN A.Name IS NOT NULL THEN A.Street2
		WHEN C.Name IS NOT NULL THEN C.Street2
		WHEN D.Name IS NOT NULL THEN D.Street2
		ELSE M.Street2
	END AS Street2,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltCity, '')
		WHEN A.Name IS NOT NULL THEN A.City
		WHEN C.Name IS NOT NULL THEN C.City
		WHEN D.Name IS NOT NULL THEN D.City
		ELSE M.City
	END AS City,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltState, '')
		WHEN A.Name IS NOT NULL THEN A.State
		WHEN C.Name IS NOT NULL THEN C.State
		WHEN D.Name IS NOT NULL THEN D.State
		ELSE M.State
	END AS State,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltZipcode, '')
		WHEN A.Name IS NOT NULL THEN A.Zipcode
		WHEN C.Name IS NOT NULL THEN C.Zipcode
		WHEN D.Name IS NOT NULL THEN D.Zipcode
		ELSE M.Zipcode
	END AS ZipCode,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltEmail, '')
		WHEN A.Name IS NOT NULL THEN A.Email
		WHEN C.Name IS NOT NULL THEN C.Email
		WHEN D.Name IS NOT NULL THEN D.Email
		ELSE ''
	END AS Email,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.AltFax, '')
		WHEN A.Name IS NOT NULL THEN A.Fax
		WHEN C.Name IS NOT NULL THEN C.Fax
		WHEN D.Name IS NOT NULL THEN D.Fax
		ELSE ''
	END AS Fax,
	LRR.AltRecipient AS AltRecipient,
	CASE
		WHEN LRR.AltRecipient = 1 THEN ISNULL(LRR.SecureRecipientID, '00000000-0000-0000-0000-000000000000')
		ELSE '00000000-0000-0000-0000-000000000000'
	END AS SecureRecipientID
	FROM LetterRequestRecipient LRR
	LEFT JOIN Master M ON LRR.AccountID = M.Number
	LEFT JOIN Attorney A ON LRR.AttorneyID = A.AttorneyID
	LEFT JOIN Customer C ON LRR.CustomerCode = C.Customer
	LEFT JOIN Debtors D ON LRR.DebtorID = D.DebtorID
	WHERE LetterRequestRecipientID = @LetterRequestRecipientID

GO
