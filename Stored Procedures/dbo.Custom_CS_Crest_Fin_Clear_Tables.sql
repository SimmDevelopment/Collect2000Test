SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CS_Crest_Fin_Clear_Tables]
	
AS
BEGIN

    -- Clear out tables for new data load
DELETE
FROM Custom_CS_Crest_Fin_Section1

DELETE
FROM Custom_CS_Crest_Fin_Section2

DELETE
FROM Custom_CS_Crest_Fin_Section3

DELETE
FROM Custom_CS_Crest_Fin_Section4

DELETE
FROM Custom_CS_Crest_Fin_Section5


END
GO
