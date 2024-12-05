SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 2013
-- Description:	Send accounts that are closed but not returned
-- Updates: 3/10/2014 changed from sending returned accounts to sending closed accounts.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Bill_Me_Later_EOM_updated] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME,
	@customer VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account AS Account, (current1 + current2) AS Balance, lastpaidamt AS [Last Payment Amount], lastpaid AS [Last Payment Date], received AS [Date Assigned],
	status AS [Status]
FROM master WITH (NOLOCK)
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND returned BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND status <> 'RCL'

END
GO
