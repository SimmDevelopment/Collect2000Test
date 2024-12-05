SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_StatusIdForDoNotUse] ()
RETURNS INT
AS BEGIN
	
	DECLARE @Output INT
	SELECT @Output = IntValue1 FROM [GlobalSettings] WHERE NameSpace = 'Custom' AND SettingName = 'Phones_StatusIdForDoNotUse' 
	RETURN ISNULL(@output,-1)
END
GO
