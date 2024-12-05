SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_TranslatePhoneMappingToDialerPhoneType](@PhoneTypeMapping INT)
RETURNS VARCHAR(8)
AS
BEGIN
IF @PhoneTypeMapping = 0 RETURN 'H'
IF @PhoneTypeMapping = 1 RETURN 'W'
IF @PhoneTypeMapping = 2 RETURN 'C'
IF @PhoneTypeMapping = 3 RETURN 'FX'
IF @PhoneTypeMapping = 4 RETURN 'SH'
IF @PhoneTypeMapping = 5 RETURN 'SW'
IF NOT @PhoneTypeMapping IS NULL RETURN 'O'
RETURN ''
END

GO
