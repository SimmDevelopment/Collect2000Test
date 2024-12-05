SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Middletown_Adjustment_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
	  
	 account, CASE WHEN z.[Wtr Swr Ele Tra (Prin +Penalty) Due] - (current1 + current2 + ISNULL((SELECT SUM(CASE WHEN batchtype LIKE '%r' THEN -(paid1 + paid2) ELSE paid1 + paid2 END) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype LIKE 'pu%'), 0)) > 0 THEN 'DAR' ELSE 'PC' END AS paymenttype, 
	z.[Wtr Swr Ele Tra (Prin +Penalty) Due] - (current1 + current2 + ISNULL((SELECT SUM(CASE WHEN batchtype LIKE '%r' THEN -(paid1 + paid2) ELSE paid1 + paid2 END) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype LIKE 'pu%'), 0)) AS adjustment, 
	z.[Wtr Swr Ele Tra (Prin +Penalty) Due] AS reportedbalance,
current1 + current2 AS simmbalance
FROM master m WITH (NOLOCK) INNER JOIN dbo.Custom_Middletown_Preload z WITH (NOLOCK) ON m.account = LTRIM(z.[Utm Id])
WHERE m.closed IS NULL AND (current1 + current2 + ISNULL((SELECT SUM(CASE WHEN batchtype LIKE '%r' THEN -(paid1 + paid2) ELSE paid1 + paid2 END) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype LIKE 'pu%'), 0)) <> z.[Wtr Swr Ele Tra (Prin +Penalty) Due]

    
	/*
	SELECT account, CASE WHEN z.[Wtr Swr Ele Tra (Prin +Penalty) Due] - (current1 + current2 + ABS(paid1 + paid2)) > 0 THEN 'DAR' ELSE 'PC' END AS paymenttype, 
	z.[Wtr Swr Ele Tra (Prin +Penalty) Due] - (current1 + current2 + ABS(paid1 + paid2)) AS adjustment, z.[Wtr Swr Ele Tra (Prin +Penalty) Due] AS reportedbalance,
current1 + current2 AS simmbalance
FROM master m WITH (NOLOCK) INNER JOIN dbo.Custom_Middletown_Preload z WITH (NOLOCK) ON m.account = LTRIM(z.[Utm Id])
WHERE m.closed IS NULL AND (current1 + current2 + ABS(paid1 + paid2)) <> z.[Wtr Swr Ele Tra (Prin +Penalty) Due]
*/
END
GO
