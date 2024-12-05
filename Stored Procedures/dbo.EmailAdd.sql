SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EmailAdd]
	@DebtorId INT,
	@Email VARCHAR(50),
	@TypeCd VARCHAR(10),
	@StatusCd VARCHAR(10),
	@Active BIT,
	@Primary BIT,
	@ConsentGiven BIT,
	@WrittenConsent BIT,
	@ConsentSource VARCHAR(255),
	@ConsentBy VARCHAR(255),
	@ConsentDate DATETIME,
	@CreatedWhen DATETIME,
	@CreatedBy VARCHAR(255),
	@ModifiedWhen DATETIME,
	@ModifiedBy VARCHAR(255),
	@comment TEXT
AS
BEGIN

INSERT INTO [dbo].[Email]
           ([DebtorId]
           ,[Email]
           ,[TypeCd]
           ,[StatusCd]
           ,[Active]
           ,[Primary]
           ,[ConsentGiven]
           ,[WrittenConsent]
           ,[ConsentSource]
           ,[ConsentBy]
           ,[ConsentDate]
           ,[CreatedWhen]
           ,[CreatedBy]
           ,[ModifiedWhen]
           ,[ModifiedBy]
           ,[comment])
     VALUES (
			@DebtorId,
			@Email,
			@TypeCd,
			@StatusCd,
			@Active,
			@Primary,
			@ConsentGiven,
			@WrittenConsent,
			@ConsentSource,
			@ConsentBy,
			@ConsentDate,
			@CreatedWhen,
			@CreatedBy,
			@ModifiedWhen,
			@ModifiedBy,
			@comment)

END

GO
