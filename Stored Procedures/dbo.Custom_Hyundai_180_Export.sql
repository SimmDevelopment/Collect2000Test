SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_180_Export] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Acct Id] , [Customer Name] , [Assignment Date] , [Days from Last Payment] , [Days from Assignment] , [Total Amt Placed]
, m.status, m.lastpaid
FROM custom_hyundai180_import c WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON CONVERT(VARCHAR(50), c.[Acct Id]) = m.account

END
GO
