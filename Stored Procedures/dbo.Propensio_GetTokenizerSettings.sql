SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[Propensio_GetTokenizerSettings] @FileNum INT = 0
AS
BEGIN
	DECLARE @TokenizerUri VARCHAR(500)
	DECLARE @LatitudeInstance VARCHAR(32)
	DECLARE @AchVendorCode VARCHAR(20)
	DECLARE @CreditCardVendorCode VARCHAR(20)
	DECLARE @AchAuth1 VARCHAR(1000)
	DECLARE @AchAuth2 VARCHAR(1000) 
	DECLARE @CreditCardAuth1 VARCHAR(1000) 
	DECLARE @CreditCardAuth2 VARCHAR(1000) 

	SET @TokenizerUri = 'http://latsqlsvr/LatitudePVG/serviceinterface.asmx';
	SET @LatitudeInstance = 'master';
	SET @AchVendorCode = 'NACHA';
	SET @CreditCardVendorCode = 'USAePay_PayScout';
	SET @AchAuth1 = 'fileformat=NACHA|immdest= 000000000|immorig= 999999999|immdestnm=BANKNAME|immorignm=SIMM ASSOCIATES|cname=FRC|fhead=HEADER ROW INFO|dfiid=03200001|companyid=133702644';
	SET @AchAuth2 = ''; 
	SET @CreditCardAuth1 = 'm55DSGBGcxMn1Kwa7FJ6UROFYMnBeKaK';
	SET @CreditCardAuth2 = '1234';

	SELECT 
	@TokenizerUri AS [TokenizerUri], 
	@LatitudeInstance AS [LatitudeInstance], 
	@AchVendorCode AS [AchVendorCode], 
	@AchAuth1 AS [AchAuth1], 
	@AchAuth2 AS [AchAuth2], 
	@CreditCardVendorCode AS [CreditCardVendorCode],
	@CreditCardAuth1 AS [CreditCardAuth1], @CreditCardAuth2 AS [CreditCardAuth2]
END

GO
