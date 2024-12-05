SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_IteratedDebtorPhonePriorityBunchItem](@number INT, @DebtorID INT, @Controls VARCHAR(4), @Position INT,
		@PhoneTypeMapping1  INT,        @Count1  INT,
		@PhoneTypeMapping2  INT = NULL, @Count2  INT = NULL,
		@PhoneTypeMapping3  INT = NULL, @Count3  INT = NULL,
		@PhoneTypeMapping4  INT = NULL, @Count4  INT = NULL,
		@PhoneTypeMapping5  INT = NULL, @Count5  INT = NULL,
		@PhoneTypeMapping6  INT = NULL, @Count6  INT = NULL,
		@PhoneTypeMapping7  INT = NULL, @Count7  INT = NULL,
		@PhoneTypeMapping8  INT = NULL, @Count8  INT = NULL,
		@PhoneTypeMapping9  INT = NULL, @Count9  INT = NULL,
		@PhoneTypeMapping10 INT = NULL, @Count10 INT = NULL,
		@PhoneTypeMapping11 INT = NULL, @Count11 INT = NULL,
		@PhoneTypeMapping12 INT = NULL, @Count12 INT = NULL,
		@PhoneTypeMapping13 INT = NULL, @Count13 INT = NULL,
		@PhoneTypeMapping14 INT = NULL, @Count14 INT = NULL,
		@PhoneTypeMapping15 INT = NULL, @Count15 INT = NULL,
		@PhoneTypeMapping16 INT = NULL, @Count16 INT = NULL
	)
RETURNS VARCHAR(30)
AS
BEGIN
RETURN ISNULL((SELECT PhoneNumber FROM dbo.Phones_IteratedDebtorPhonePriorityBunchList(@number, @DebtorID, @Controls, @PhoneTypeMapping1, @Count1, @PhoneTypeMapping2, @Count2, @PhoneTypeMapping3, @Count3, @PhoneTypeMapping4, @Count4, @PhoneTypeMapping5, @Count5, @PhoneTypeMapping6, @Count6, @PhoneTypeMapping7, @Count7, @PhoneTypeMapping8, @Count8, @PhoneTypeMapping9, @Count9, @PhoneTypeMapping10, @Count10, @PhoneTypeMapping11, @Count11, @PhoneTypeMapping12, @Count12, @PhoneTypeMapping13, @Count13, @PhoneTypeMapping14, @Count14, @PhoneTypeMapping15, @Count15, @PhoneTypeMapping16, @Count16) WHERE Position = @Position), '')
END

GO
