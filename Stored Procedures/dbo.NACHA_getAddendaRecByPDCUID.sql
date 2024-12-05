SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NACHA_getAddendaRecByPDCUID] 
	@pdcuid int
AS
BEGIN

--customize logic here to return a formatted addenda record using the PDC UID
SELECT TOP 1 desk + '*' + checknbr from pdc where [uid] = @pdcuid
	
END
GO
