SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_IteratedDebtorPhonePriorityItemType](@number INT, @DebtorID INT, @PhoneTypeMapping INT, @Controls VARCHAR(4), @Position INT)
RETURNS VARCHAR(8)
AS
BEGIN
RETURN dbo.Phones_TranslatePhoneMappingToDialerPhoneType((SELECT PhoneTypeMapping FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping, @Controls) WHERE Position = @Position))
END

GO
