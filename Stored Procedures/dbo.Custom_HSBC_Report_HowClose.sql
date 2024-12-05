SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_HSBC_Report_HowClose]
@date datetime
AS

SELECT m.account, m.status
FROM Custom_HSBC_HowClose hc INNER JOIN master m 
	ON hc.Account = m.account
WHERE hc.Date = @date
ORDER by m.account
GO
