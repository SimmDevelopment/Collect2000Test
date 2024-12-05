SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[LetterRequestRTF2PDFSettings]
AS
SELECT [BitValue] AS NewDataIsPDF, [DateValue1] AS NewDataIsPDFWhen, [DateValue2] AS ConvertedToProcessDate
FROM [dbo].[GlobalSettings]
WHERE [NameSpace] = 'LetterRequestRTF2PDF' AND [SettingName] = 'RTF2PDF Processing'
GO
