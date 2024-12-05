SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Klarna_WebBank_Recon]

	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.Account, m.current1 + m.current2 + m.current3 AS [Current Bal], esd.CurrentMinDue AS [Min Due],CASE customer WHEN '0001522' THEN 'Revolving/Early Stage' WHEN '0001787' THEN 'Pay Reminder' WHEN '0001788' THEN 'Post Chargeoff' End AS Stream
FROM master m WITH (NOLOCK) INNER JOIN EarlyStageData esd WITH (NOLOCK) ON m.number = esd.AccountID
WHERE customer IN ('0001522','0001787','0001788','0002213','0002610') AND closed IS NULL


END
GO
