SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateContactEx]

@ContactID int,
@GroupID int,
@Prefix char(5),
@FirstName varchar(50),
@MiddleName varchar(50),
@LastName varchar(50),
@Suffix char(5),
@Phone varchar(50),
@Direct varchar(50),
@Home varchar(50),
@Mobile varchar(50),
@Fax varchar(50),
@DebtorLine varchar(50),
@OtherPhone varchar(50),
@Address varchar(50),
@Address2 varchar(50),
@City varchar(50),
@State varchar(50),
@Zip varchar(50),
@Email varchar(50),
@Email2 varchar(50),
@WebSite varchar(200),
@Role varchar(200),
@Company varchar(200),
@ReferredBy varchar(50),
@Source varchar(50),
@ConfidentialityReceived bit,
@QuestionnaireReceived bit,
@CreatedBy varchar(50),
@UpdatedBy varchar(50),
@CreatedOn datetime,
@UpdatedOn datetime,
@OwnershipPercentage float



AS

UPDATE [dbo].[AIM_Contact]
   SET 
		
      
      [Prefix] =					@Prefix
      ,[FirstName] =				@FirstName
      ,[MiddleName] =				@MiddleName
      ,[LastName] =					@LastName
      ,[Suffix] =					@Suffix
      ,[Phone] =					@Phone
      ,[Direct] =					@Direct
      ,[Home] =						@Home
      ,[Mobile] =					@Mobile
      ,[Fax] =						@Fax
      ,[DebtorLine] =				@DebtorLine
      ,[OtherPhone] =				@OtherPhone
      ,[Address] =					@Address
      ,[Address2] =					@Address2
      ,[City] =						@City
      ,[State] =					@State
      ,[Zip] =						@Zip
      ,[Email] =					@Email
      ,[Email2] =					@Email2
      ,[WebSite] =					@WebSite
      ,[Role] =						@Role
      ,[Company] =					@Company
      ,[ReferredBy] =				@ReferredBy
      ,[Source] =					@Source
      ,[ConfidentialityReceived] =	@ConfidentialityReceived
      ,[QuestionnaireReceived] =	@QuestionnaireReceived
      ,[CreatedBy] =				@CreatedBy
      ,[UpdatedBy] =				@UpdatedBy
      ,[CreatedOn] =				@CreatedOn
      ,[UpdatedOn] =				@UpdatedOn

 WHERE ContactID = @ContactID


UPDATE AIM_GroupContactAssn
SET OwnershipPercentage = @OwnershipPercentage
WHERE ContactId = @ContactID AND GroupId = @GroupID



GO
