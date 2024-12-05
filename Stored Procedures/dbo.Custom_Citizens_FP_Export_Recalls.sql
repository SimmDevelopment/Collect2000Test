SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_Recalls] 

AS
BEGIN

	SET NOCOUNT ON;

SELECT account
FROM master m WITH (NOLOCK)
WHERE account NOT IN (SELECT acct_num FROM Custom_Citizens_First_Party_Master_Temp_File c WITH (NOLOCK) WHERE c_flag IN ('Y', '1'))
AND customer = '0002226' AND closed IS NULL

END
GO
