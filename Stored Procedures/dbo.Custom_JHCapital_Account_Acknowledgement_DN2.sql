SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
-- 9/11/2017 BGM Update to new DN2 system.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Account_Acknowledgement_DN2]
	-- Add the parameters for the stored procedure here
	
	@startDate datetime,
	@endDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT m.id1 AS data_id,
		CASE 	WHEN dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) THEN '100000'
				end AS activitytype_id,
		CASE 	WHEN dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) THEN 'Acknowledged'
				end AS activity_type,
		CASE 	WHEN dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) THEN CONVERT(VARCHAR(10), m.received, 101)
				end AS activity_date,
		CONVERT(VARCHAR(9), m.number) AS activity_collector_code
FROM master m WITH (NOLOCK)
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) and id2 not in ('AllGate' ,'ARS-JMET')



END
GO
