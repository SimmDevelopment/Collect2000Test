SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_GetPolicySettingChoices] @xml NTEXT, @id NVARCHAR(260)
AS
SET NOCOUNT ON;

DECLARE @idoc INTEGER;

EXEC sp_xml_preparedocument @idoc OUTPUT, @xml, '<Policy xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.debtsoftware.com/Latitude/Policies" />';

IF @@ERROR != 0
	RETURN 1;

DECLARE @results TABLE (
	[type] VARCHAR(50) NULL,
	[value] SQL_VARIANT NULL,
	[description] VARCHAR(260) NULL
);

INSERT INTO @results ([type], [value], [description])
SELECT [type], [value], [description]
FROM OPENXML(@idoc, '//p:Policy/p:Setting/p:ArrayOfChoice/p:Choice', 8)
WITH ([id] VARCHAR(260) '../../@id',
	[description] VARCHAR(260) '@description',
	[value] SQL_VARIANT 'p:Value',
	[type] VARCHAR(50) 'p:Value/@xsi:type')
WHERE [id] = @id;

UPDATE @results
SET [value] = CASE
		WHEN [value] = 'true' THEN CAST(1 AS BIT)
		WHEN [value] = 'false' THEN CAST(0 AS BIT)
		ELSE CAST(NULL AS BIT)
	END
WHERE [type] = 'xsd:Boolean';

UPDATE @results
SET [value] = CAST([value] AS MONEY)
WHERE [type] IN ('xsd:Decimal', 'xsd:integer', 'xsd:float', 'xsd:byte', 'xsd:short', 'xsd:int', 'xsd:long', 'xsd:float', 'xsd:double', 'xsd:unsignedByte', 'xsd:unsignedShort', 'xsd:unsignedInt', 'xsd:unsignedLong');

SELECT [value], [description]
FROM @results;

EXEC sp_xml_removedocument @idoc;

RETURN 0; 

GO
