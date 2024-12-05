SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_AddWallet]
  --Wallet columns--
  @ModeStatus varchar(14),
  @LastOperation varchar(14),
  @Type varchar(14),
  @PaymentVendorTokenId integer,
  @DebtorId integer,
  @SearchKey varchar(14),
  @AccountNumber varchar(50),
  @InstitutionCode varchar(50),
  @AccountType varchar(14),
  @PayorName varchar(100),
  @CCExpiration datetime,
  @AllowedWhenEarly datetime,
  @AllowedWhenLate datetime,
  @DisplayName varchar(50),
  @DisplayOrder integer,
  @CreatedWhen datetimeoffset(7) ,
  @CreatedBy varchar(20) ,
  @UpdatedWhen datetimeoffset(7) ,
  @UpdatedBy varchar(20),
  @WalletId INTEGER OUTPUT,

  --Wallet Contact Columns--
  @AccountAddress1 nvarchar(50),
    @AccountAddress2 nvarchar(50),
    @AccountCity nvarchar(30),
    @AccountState nvarchar(3),
    @AccountZipcode nvarchar(10),
    @BankAddress nvarchar(50),
    @BankCity nvarchar(30),
    @BankState nvarchar(3),
    @BankZipcode nvarchar(10),
    @BankName nvarchar(50),
    @BankPhone nvarchar(20)
AS
SET NOCOUNT ON;
INSERT INTO [dbo].[Wallet]
           ([ModeStatus]
           ,[LastOperation]
           ,[Type]
           ,[PaymentVendorTokenId]
           ,[DebtorId]
           ,[SearchKey]
           ,[AccountNumber]
           ,[InstitutionCode]
           ,[AccountType]
           ,[PayorName]
           ,[CCExpiration]
           ,[AllowedWhenEarly]
           ,[AllowedWhenLate]
           ,[DisplayName]
           ,[DisplayOrder]
           ,[CreatedWhen]
           ,[CreatedBy]
           ,[UpdatedWhen]
           ,[UpdatedBy])
     VALUES
           (@ModeStatus,
       @LastOperation,
       @Type,
       @PaymentVendorTokenId, 
       @DebtorId, 
       @SearchKey,
       @AccountNumber,
       @InstitutionCode,
       @AccountType,
       @PayorName,
       @CCExpiration, 
       @AllowedWhenEarly, 
       @AllowedWhenLate, 
       @DisplayName,
       @DisplayOrder, 
       @CreatedWhen, 
       @CreatedBy,
       @UpdatedWhen, 
       @UpdatedBy)

SET @WalletId = SCOPE_IDENTITY();

INSERT INTO [dbo].[WalletContact]
           ([WalletId]
           ,[AccountAddress1]
           ,[AccountAddress2]
           ,[AccountCity]
           ,[AccountState]
           ,[AccountZipcode]
           ,[BankAddress]
           ,[BankCity]
           ,[BankState]
           ,[BankZipcode]
           ,[BankName]
           ,[BankPhone])
     VALUES
           (@WalletId,
           @AccountAddress1, 
           @AccountAddress2, 
           @AccountCity, 
           @AccountState,            
           @AccountZipcode, 
           @BankAddress, 
           @BankCity, 
           @BankState,            
           @BankZipcode, 
           @BankName, 
           (SELECT TOP 1 Phone FROM ABA WHERE ABA.MICR = @InstitutionCode))

RETURN 0;SET ANSI_NULLS ON
GO
