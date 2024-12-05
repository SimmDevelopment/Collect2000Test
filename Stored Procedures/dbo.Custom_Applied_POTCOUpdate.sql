SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Applied_POTCOUpdate]
@number int
AS

UPDATE EarlyStageData
SET Substatuses = 'POTCO'
WHERE AccountID = @number
GO
