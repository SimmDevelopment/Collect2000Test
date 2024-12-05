SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/11/2021
-- Description:	Send received acknowldgement on new/reopen placements
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_C360_RMS_Acknowledgement_New] 

--exec Custom_SunTrust_CACS_C360_RMS_Acknowledgement_New '20210731', '20210806'

	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account AS [STB Acct #], Name AS [NAME], m.number AS [Agency Acct #], m.original1 AS [ PN-ASSIGN ],CONVERT(VARCHAR(10), m.received, 101) AS [DT-ASSIGN],m.customer as [Customer]
FROM master m WITH (NOLOCK) 
WHERE (SELECT TOP 1 thedata FROM miscextra me WITH (NOLOCK) WHERE m.number = me.number AND me.Title = 'RecvDate') BETWEEN @startDate AND @endDate AND 
((customer IN ('0002258', '0002259', '0002512')) OR (customer ='0002509' AND (SELECT TOP 1 thedata FROM MiscExtra me WITH (NOLOCK) WHERE me.Number = m.number AND me.Title = 'Pla.0.AgencyId') = 'A0000008') 
OR (customer ='0002510' AND (SELECT TOP 1 thedata FROM MiscExtra me WITH (NOLOCK) WHERE me.Number = m.number AND me.Title = 'Pla.0.AgencyId') = 'A0000008') 
OR (customer ='0002513' AND (SELECT TOP 1 thedata FROM MiscExtra me WITH (NOLOCK) WHERE me.Number = m.number AND me.Title = 'Pla.0.AgencyId') = 'A0000008') 
OR (customer ='0002514' AND (SELECT TOP 1 thedata FROM MiscExtra me WITH (NOLOCK) WHERE me.Number = m.number AND me.Title = 'Pla.0.AgencyId') = 'A0000008') 
)



END
GO
