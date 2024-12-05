SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnFormatXmlAsCsv](@input XML)
RETURNS NVARCHAR(MAX)
BEGIN
	IF @input IS NULL BEGIN
		RETURN NULL;
	END;
	SET @input = (
		SELECT DISTINCT RTRIM([nodes].[xml].value('(text())[1]', 'nvarchar(max)')) AS [value]
		FROM @input.nodes('/root/item/*') AS [nodes]([xml])
		ORDER BY [value]
		FOR XML PATH('item'), ROOT('root'), ELEMENTS, TYPE
	);
	
	DECLARE @csv NVARCHAR(MAX);
	DECLARE @len INTEGER;
	SET @csv = CAST(@input.query(N'
		for $item in /root/item/*/text()
			return concat(''"'', $item, ''", '')
	') AS NVARCHAR(MAX));
	SET @len = LEN(@csv);
	SET @csv = SUBSTRING(@csv, 1, @len - 1);
	RETURN @csv;
END

GO
