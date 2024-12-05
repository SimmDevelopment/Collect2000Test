SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[LetterRequestRTF2PDF_Insert]
AS
BEGIN
	DECLARE @ConvertedToProcessDate DATETIME
	DECLARE @NewDataISPDFWhen DATETIME
	
	SELECT @NewDataISPDFWhen = ISNULL(NewDataISPDFWhen, GETUTCDATE()), @ConvertedToProcessDate = ISNULL(ConvertedToProcessDate, '1753-01-02') FROM LetterRequestRTF2PDFSettings

	INSERT INTO dbo.LetterRequestRTF2PDF (LetterRequestId, SizeBefore)
	SELECT lr.LetterRequestID, LEN(lr.DocumentData) AS sizeBefore
	FROM dbo.LetterRequest lr
	WHERE lr.DateProcessed BETWEEN @ConvertedToProcessDate AND @NewDataISPDFWhen
		--AND lr.SaveImage = 1 
		AND lr.DocumentData IS NOT NULL 
		AND LEN(lr.DocumentData) > 0 
		AND lr.LetterRequestID NOT IN (SELECT LetterRequestID FROM dbo.LetterRequestRTF2PDF)
	
	RETURN @@ROWCOUNT
END
GO
