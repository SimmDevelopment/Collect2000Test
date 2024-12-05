SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EmailConsentUpdate]
	@EmailId INT,
	@Active BIT,
	@Comment TEXT,
	@ConsentBy VARCHAR(255),
	@ConsentGiven BIT,
	@ConsentSource VARCHAR(255),
	@Primary BIT,
	@WrittenConsent BIT,
	@ModifiedBy VARCHAR(255),
	@StatusCd VARCHAR(10)
AS
BEGIN

INSERT INTO [dbo].[EmailDebtorsHistory]
SELECT emailid
	 , debtorid
	 , email
	 , typecd
	 , statuscd
	 , active
	 , [primary]
	 , consentgiven
	 , writtenconsent
	 , consentsource
	 , consentby
	 , consentdate
	 , createdwhen
	 , createdby
	 , modifiedwhen
	 , modifiedby
	 , comment
FROM Email
WHERE EmailId = @EmailId

UPDATE dbo.Email
SET Active = @Active
	,comment = @Comment
	,ConsentBy = @ConsentBy
	,ConsentGiven = @ConsentGiven
	,ConsentSource = @ConsentSource
	,ConsentDate = CASE WHEN @ConsentGiven = 0 THEN NULL ELSE COALESCE(ConsentDate, GETDATE()) END
	,[Primary] = @Primary
	,WrittenConsent = @WrittenConsent
	,StatusCd = @StatusCd
	,ModifiedBy = @ModifiedBy
	,ModifiedWhen = GETDATE()
WHERE EmailId = @EmailId

END

GO
