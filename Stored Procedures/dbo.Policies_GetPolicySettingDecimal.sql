SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_GetPolicySettingDecimal] @xml NTEXT, @id NVARCHAR(260), @value MONEY OUTPUT
AS
SET NOCOUNT ON;

DECLARE @idoc INTEGER;

EXEC sp_xml_preparedocument @idoc OUTPUT, @xml, '<Policy xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.debtsoftware.com/Latitude/Policies" />';

IF @@ERROR != 0
	RETURN 1;

SELECT TOP 1 @value = [value]
FROM OPENXML(@idoc, '//p:Policy/p:Setting', 8)
WITH ([id] VARCHAR(260) '@id',
	[value] MONEY 'p:decimal')
WHERE [id] = @id;

EXEC sp_xml_removedocument @idoc;

RETURN 0; 

GO
