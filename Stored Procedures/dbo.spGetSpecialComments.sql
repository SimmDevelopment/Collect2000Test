SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[spGetSpecialComments]  
AS  
BEGIN  
 SELECT ID, Code + ' - ' + Description AS ListCode, Code FROM Custom_ListData WHERE ListCode = 'CBRSPECCMT';  
END
GO
