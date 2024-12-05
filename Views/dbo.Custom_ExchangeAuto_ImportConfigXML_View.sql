SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[Custom_ExchangeAuto_ImportConfigXML_View] AS
WITH XMLData AS (
    SELECT 
        ID,  -- Replace with the actual unique identifier column of your table
        importconfigxml,
        CAST(importconfigxml AS XML) AS XMLContent
    FROM 
        custom_exchangeauto
)
SELECT 
    d.ID,
    c.value('@Name', 'VARCHAR(100)') AS ConfigName,
    c.value('@StopOnError', 'VARCHAR(10)') AS StopOnError,
    c.value('@AttachErrorFilesForImport', 'VARCHAR(10)') AS AttachErrorFilesForImport,
    p.value('@Type', 'VARCHAR(50)') AS ProcessType,
    p.value('@ClientPath', 'VARCHAR(255)') AS ClientPath,
    p.value('@InterfaceName', 'VARCHAR(100)') AS InterfaceName,
    p.value('@Sequence', 'INT') AS Sequence,
    p.value('@ExportID', 'VARCHAR(50)') AS ExportID,
    p.value('@IncludeFileAsAttachment', 'VARCHAR(10)') AS IncludeFileAsAttachment
FROM 
    XMLData d
    CROSS APPLY d.XMLContent.nodes('/ImportConfig') AS tab(c)
    CROSS APPLY c.nodes('Process') AS tab2(p);
GO
