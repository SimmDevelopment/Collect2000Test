SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[Custom_Middletown_PIF_File] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account, 'PC' AS paymenttype, current1 + current2 AS adjustment, '' AS reportedbalance, current1 + current2 AS simmbalance
FROM master WITH (NOLOCK)
WHERE account NOT IN (
SELECT RTRIM(LTRIM([utm id]))
FROM Custom_Middletown_Preload WITH (NOLOCK)
)
AND closed IS NULL AND customer IN ('0000110')


END
GO
