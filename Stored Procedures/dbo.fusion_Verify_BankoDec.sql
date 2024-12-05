SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Verify_BankoDec]
AS
BEGIN
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_BankoDecFindOriginalRequestIdBanko')
	RAISERROR (N'fusion_BankoDecFindOriginalRequestIdBanko stored proc missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_BankoDecFindOriginalRequestIdDec')
	RAISERROR (N'fusion_BankoDecFindOriginalRequestIdDec stored proc missing',15,1,N'number',5);
END
GO
