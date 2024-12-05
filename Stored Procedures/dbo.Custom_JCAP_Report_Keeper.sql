SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_JCAP_Report_Keeper]
@date datetime

AS

SELECT account
FROM master m INNER JOIN Custom_JCAPKeeper j
	ON m.number = j.number
WHERE j.Date = @date
GO
