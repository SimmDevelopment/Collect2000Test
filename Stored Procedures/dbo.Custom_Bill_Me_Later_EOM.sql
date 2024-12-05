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
CREATE PROCEDURE [dbo].[Custom_Bill_Me_Later_EOM] 
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account AS Account, CASE customer WHEN '0001220' THEN 'Deceased' WHEN '0001256' THEN 'Primes' WHEN '0001257' THEN 'Tertiary' WHEN '0001258' THEN 'BK Pending' END AS Channel, 
	name AS Name, ssn AS SSN, (current1 + current2) AS Balance, street1 AS [Street 1], street2 AS [Street 2], homephone AS [Phone], city AS City, state AS State, 
	Zipcode, worked AS [Last Work Date], ABS(paid1) + ABS(paid2) AS [Total Paid], lastpaidamt AS [Last Payment Amount], lastpaid AS [Last Payment Date], received AS [Date Assigned],
	status AS [Status]
FROM master WITH (NOLOCK)
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND closed IS NULL

END
GO
