SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_GetPolicySettingBoolean] @xml NTEXT, @id NVARCHAR(260), @value BIT OUTPUT
AS
SET NOCOUNT ON;

DECLARE @idoc INTEGER;

EXEC sp_xml_preparedocument @idoc OUTPUT, @xml, '<Policy xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.debtsoftware.com/Latitude/Policies" />';

IF @@ERROR != 0
	RETURN 1;

SELECT TOP 1 @value = CASE
	WHEN [value] = 'true' THEN CAST(1 AS BIT)
	WHEN [value] = 'false' THEN CAST(0 AS BIT)
	ELSE CAST(NULL AS BIT)
END
FROM OPENXML(@idoc, '//p:Policy/p:Setting', 8)
WITH ([id] VARCHAR(260) '@id',
	[value] CHAR(5) 'p:boolean')
WHERE [id] = @id;

EXEC sp_xml_removedocument @idoc;

RETURN 0;

GO
