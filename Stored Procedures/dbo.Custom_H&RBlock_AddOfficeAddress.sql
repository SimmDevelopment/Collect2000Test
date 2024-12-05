SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_H&RBlock_AddOfficeAddress]
@number int
AS

INSERT MiscExtra (Number, Title, TheData)
SELECT number, 'Office Address', OFADDR + ' ' + OFADD2 + ' ' + OFCITY + ', ' + OFSTA + ' ' + OFZIPC
FROM [Custom_H&RBlock_Offices] INNER JOIN master 
	ON OfficeID = id1
WHERE number = @number
GO
