SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Demographic_UpdateEmail]
	@file_number int,
	@debtor_number int,
	@PreferredMethod varchar(50) = 'None',
	@EmailAddress varchar(50),
	@EmailType varchar(50),
	@ConsentToEmail varchar(1),
	@Method int,
	@ObtainedFrom varchar(50),
	@EffectiveDate datetime,
	@Comment varchar(50),
	@WorkEmail varchar(1),
	@agencyId int
AS
BEGIN

	DECLARE @Identity_EmailId INT
	DECLARE @SavedEmailId varchar(50)
	
	declare @masterNumber int,@currentAgencyId int;
	select @masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number
	
	declare @agencyname varchar(100)
	select @agencyname = name from aim_agency where agencyid = @agencyid
	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	if(@masterNumber <> @file_number)
	begin
		RAISERROR ('15008',16,1)
		return
	end
	if(@currentAgencyId is null or (@currentAgencyId <> @agencyId))
	begin
		raiserror ('15004', 16, 1)
		return
	end
	

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @file_number

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END
	    
SELECT @SavedEmailId=Email FROM email WHERE 
(DebtorId=@debtor_number)

 
 IF(ISNULL(@ConsentToEmail,'')<>'')
	 BEGIN 
	 SELECT @ConsentToEmail = CASE WHEN @ConsentToEmail='Y' THEN '1' ELSE '0' 
	 END 
 END
  IF(ISNULL(@Method,'')='')
	 BEGIN 
	 SET @Method = 0 	  
 END

IF(ISNULL(@PreferredMethod,'')<>'')
	 BEGIN 
	 SET @PreferredMethod = CASE 
	 WHEN @PreferredMethod='1' THEN 'Letter'
	 WHEN @PreferredMethod='2' THEN 'Phone'
	 WHEN @PreferredMethod='3' THEN 'Email'
	 WHEN @PreferredMethod='4' THEN 'SMS'
	  ELSE 'None' 
	 END ;
 END

 SET @EmailType = CASE @WorkEmail WHEN 'Y' THEN 'Work' ELSE 'Home' END;

 IF(ISNULL(@SavedEmailId,'') <> @EmailAddress)
 BEGIN
	INSERT INTO Email (DebtorAssociationId,DebtorId,Email,TypeCd,StatusCd,Active,[Primary],ConsentGiven,WrittenConsent,ConsentSource,ConsentBy,ConsentDate,CreatedWhen,CreatedBy,ModifiedWhen,ModifiedBy,comment)
	VALUES(@debtor_number,@debtor_number,@EmailAddress,@EmailType,'Good',1,1,@ConsentToEmail,CAST(@Method AS BIT),@ObtainedFrom,'Receiver',@EffectiveDate,@EffectiveDate,'Receiver',@EffectiveDate,'Receiver',@Comment)
END
ELSE
UPDATE Email SET TypeCd=@EmailType,ConsentGiven=@ConsentToEmail,WrittenConsent=CAST(@Method AS BIT),ConsentSource=@ObtainedFrom,CreatedWhen=@EffectiveDate,ModifiedWhen=@EffectiveDate,comment=@Comment,ModifiedBy='Receiver'
WHERE ( debtorid =@debtor_number )

UPDATE Debtors SET ContactMethod=@PreferredMethod WHERE DebtorID=@debtor_number

INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@file_number,GETUTCDATE(),'Receiver','+++++','+++++','Email information has been updated from Agency/Attonrney',0)

END
GO
