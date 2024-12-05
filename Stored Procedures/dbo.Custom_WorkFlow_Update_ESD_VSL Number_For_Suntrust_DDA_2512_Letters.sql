SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WorkFlow_Update_ESD_VSL Number_For_Suntrust_DDA_2512_Letters]
	-- Add the parameters for the stored procedure here
	--@acctID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	UPDATE EarlyStageData
	SET current30 = ROUND(CAST(CEILING(((current1 + current2) * .60) * 100) / 100 AS MONEY), 2) ,
		current60 = ROUND(CAST(CEILING((((current1 + current2) * .65) / 2) * 100) / 100 AS MONEY), 2)
	FROM master m WITH (NOLOCK) INNER JOIN #WorkFlowAcct w ON m.number = w.[AccountID]
	WHERE customer = '0000612'
	AND m.number = AccountID 


    INSERT INTO EarlyStageData
        ( AccountID ,
          current30,
          current60                                       
        )
SELECT distinct m.number, ROUND(CAST(CEILING(((current1 + current2) * .60) * 100) / 100 AS MONEY), 2) ,
	ROUND(CAST(CEILING((((current1 + current2) * .65) / 2) * 100) / 100 AS MONEY), 2)
FROM master m WITH (NOLOCK) INNER JOIN #WorkFlowAcct w ON m.number = w.[AccountID]
WHERE customer IN ('0000612') 
AND m.number NOT IN (SELECT AccountID FROM EarlyStageData esd WITH (NOLOCK))
	
--custmer 2512 will not update the userdate field until first contact has been made since it is mailed on first contact
UPDATE master
SET userdate1 = DATEADD(dd, 51, GETDATE()), userdate2 = DATEADD(dd, 66, GETDATE())
WHERE customer IN ('0000612') AND number IN (SELECT AccountID FROM #WorkFlowAcct)

END

RETURN 0;
GO
