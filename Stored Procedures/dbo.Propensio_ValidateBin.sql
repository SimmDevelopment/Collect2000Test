SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ryan Mack
-- Create date: 2019/01/04
-- Description:	Check bin numbers for debit only clients
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_ValidateBin] 
	@FileNum INT, 
	@BinCode varchar(6)
AS
BEGIN
	DECLARE @IsValid BIT
	SET @IsValid = 1

	IF EXISTS(SELECT 1 FROM master WHERE number = @FileNum 
	AND (customer IN (select customerid from fact with (nolock) where customgroupid = 290) 
		OR customer IN ('0001220', '0001256', '0001257', '0001258', '0001747', '0001748', '0001749', '0001052')))
		IF EXISTS(SELECT 1 FROM Custom_BINS_Lookup WHERE BIN = @BinCode AND Card_Type LIKE 'CREDIT')
			SET @IsValid = 0

	SELECT @IsValid [IsValid]
END
GO
