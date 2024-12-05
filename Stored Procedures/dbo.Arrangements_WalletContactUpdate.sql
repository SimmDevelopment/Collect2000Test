SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_WalletContactUpdate] 
@WalletId INTEGER,
@Address1 nvarchar(50),
@Address2 nvarchar(50),
@City nvarchar(30),
@State nvarchar(3),
@ZipCode nvarchar(10)

AS

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE [dbo].[WalletContact]
   SET [AccountAddress1] = @Address1
      ,[AccountAddress2] = @Address2
      ,[AccountCity] = @City
      ,[AccountState] = @State
      ,[AccountZipcode] = @ZipCode
 WHERE [WalletId] = @WalletId


RETURN 0;
SET ANSI_NULLS ON
GO
