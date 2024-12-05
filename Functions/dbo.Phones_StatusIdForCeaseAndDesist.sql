SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_StatusIdForCeaseAndDesist] ()
RETURNS INT
AS BEGIN
	
	DECLARE @Output INT
	SELECT @Output = IntValue1 FROM [GlobalSettings] WHERE NameSpace = 'Custom' AND SettingName = 'Phones_StatusIdForCeaseAndDesist' 
	RETURN ISNULL(@output,-1)
END
GO
