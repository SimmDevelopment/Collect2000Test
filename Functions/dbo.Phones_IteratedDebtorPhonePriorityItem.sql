SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_IteratedDebtorPhonePriorityItem](@number INT, @DebtorID INT, @PhoneTypeMapping INT, @Controls VARCHAR(4), @Position INT)
RETURNS VARCHAR(30)
AS
BEGIN
RETURN ISNULL((SELECT PhoneNumber FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping, @Controls) WHERE Position = @Position), '')
END

GO
