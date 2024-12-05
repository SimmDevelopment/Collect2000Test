SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessEmail]
	@file_number int,
	@debtor_number int,
	@PreferredMethod varchar(50),
	@EmailAddress varchar(50),
	@EmailType varchar(50),
	@ConsentToEmail varchar(1),
	@Method int,
	@ObtainedFrom varchar(50),
	@EffectiveDate datetime,
	@Comment varchar(50),
	@WorkEmail varchar(1),
	@clientid int
AS
BEGIN

	DECLARE @Identity_EmailId INT
	DECLARE @SavedEmailId varchar(50)
	DECLARE @number int
	select @number = max(receivernumber)
	from receiver_reference rr with (nolock) 
	join master m with (nolock) on rr.receivernumber = m.number
	where sendernumber= @file_number and clientid = @clientid

	IF(@number is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @number

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END

		DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	join master m with (nolock) on d.number = m.number and m.number=@number
	where rd.SenderDebtorId = @debtor_number
	and 
	clientid = @clientid

	IF(@dnumber IS NULL)
	BEGIN
	SELECT @dnumber=MAX(d.Debtorid) from Debtors as D inner join [Master] as m on d.Number=M.number
	WHERE M.number=@number
	END
	    
SELECT @SavedEmailId=Email FROM email WHERE ( debtorid = @dnumber )

 
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
	 SELECT @PreferredMethod = CASE 
	 WHEN @PreferredMethod='1' THEN 'Letter'
	 WHEN @PreferredMethod='2' THEN 'Phone'
	 WHEN @PreferredMethod='3' THEN 'Email'
	 WHEN @PreferredMethod='4' THEN 'SMS'
	  ELSE 'Unknown' 
	 END 
 END

 IF(ISNULL(@SavedEmailId,'') <> @EmailAddress)
 BEGIN
	INSERT INTO Email (DebtorAssociationId,DebtorId,Email,TypeCd,StatusCd,Active,[Primary],ConsentGiven,WrittenConsent,ConsentSource,ConsentBy,ConsentDate,CreatedWhen,CreatedBy,ModifiedWhen,ModifiedBy,comment)
	VALUES(@dnumber,@dnumber,@EmailAddress,@EmailType,'Good',1,1,@ConsentToEmail,CAST(@Method AS BIT),@ObtainedFrom,'AIM',@EffectiveDate,@EffectiveDate,'AIM',@EffectiveDate,'AIM',@Comment)
END
ELSE
UPDATE Email SET TypeCd=@EmailType,ConsentGiven=@ConsentToEmail,WrittenConsent=CAST(@Method AS BIT),ConsentSource=@ObtainedFrom,CreatedWhen=@EffectiveDate,ModifiedWhen=@EffectiveDate,comment=@Comment,ModifiedBy='AIM'
WHERE ( debtorid =@dnumber )

UPDATE Debtors SET ContactMethod=@PreferredMethod WHERE DebtorID=@dnumber

INSERT INTO Notes (number,created,user0,action,result,comment,isprivate)
VALUES (@number,GETUTCDATE(),'AIM','+++++','+++++','Email information has been updated from client',0)
	

END
GO
