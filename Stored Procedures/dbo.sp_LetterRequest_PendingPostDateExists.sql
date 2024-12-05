SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Description:	Determine if a particular letter code has a pending request in postdates.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.sp_LetterRequest_PendingPostDateExists.sql $
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-06-30   Time: 14:15:05-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Case 42285 
-- =============================================
CREATE Procedure [dbo].[sp_LetterRequest_PendingPostDateExists]
	@LetterCode varchar(5)
AS

IF EXISTS
(
	SELECT NITDLetterCode
	FROM PMethod
	WHERE NITDLetterCode = @LetterCode
)
BEGIN
	RETURN 1
END

IF EXISTS
(
	SELECT LtrCode
	FROM pdc
	WHERE LtrCode = @LetterCode AND active = 1 AND nitd IS NULL
)
BEGIN
	RETURN 1
END

IF EXISTS
(
	SELECT LetterCode
	FROM DebtorCreditCards
	WHERE LetterCode = @LetterCode AND IsActive = 1 AND NITDSentDate IS NULL
)
BEGIN
	RETURN 1
END

IF EXISTS
(
	SELECT LetterCode
	FROM Promises
	WHERE LetterCode = @LetterCode AND Active = 1 AND RMSentDate IS NULL AND ISNULL(SendRM,0) = 1
)
BEGIN
	RETURN 1
END

RETURN 0

GO
