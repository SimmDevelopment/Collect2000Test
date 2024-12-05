SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Resurgent_Export_Email_Details] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.name AS [Consumer Name], m.id1 AS [Account ID], d.email AS [Email Address], (SELECT TOP 1 CONVERT(VARCHAR(10), dateprocessed, 101) FROM LetterRequest WITH (NOLOCK) WHERE m.number = AccountID AND LetterCode = 'email' ORDER BY DateProcessed DESC) AS [Date Last Email Sent],
CASE WHEN crea.opens > 0 THEN 1 ELSE 0 END AS [Email Opened Flag], 0 AS [Email Attachment Opened Flag],
CASE WHEN d.email IN (SELECT TOP 1 email FROM Custom_Bounced_Emails WITH (NOLOCK)) THEN 1 ELSE 0 END AS [Bad Email Address Flag],
CASE WHEN d.Email IN (SELECT TOP 1 email FROM Custom_Resurgent_Email_Unsubscribes WITH (NOLOCK)) THEN 1 ELSE 0 END AS [Unsubscribe Flag],
isnull((SELECT TOP 1 CONVERT(VARCHAR(10), CampaignDate, 101) FROM Custom_Resurgent_Email_Unsubscribes WITH (NOLOCK) WHERE d.email = Email ORDER BY CampaignDate), '') AS [Unsubscribe Date],
isnull((SELECT TOP 1 CONVERT(VARCHAR(10), CampaignDate, 101) FROM Custom_Resurgent_Email_Activity WITH (NOLOCK) WHERE d.email = Email AND prints > 0 ORDER BY CampaignDate desc), '') AS [Email Printed Date]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
LEFT OUTER JOIN Custom_Resurgent_Email_Activity crea WITH (NOLOCK) ON d.Email = crea.email
WHERE Customer IN ('0001457', '0001466') AND m.number IN (SELECT accountid FROM LetterRequest lr WITH (NOLOCK) WHERE LetterCode = 'email' AND CustomerCode IN ('0001457', '0001466'))

END
GO
