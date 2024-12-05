SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Inventory]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.customtext1, m.account, m.current1 + m.current2, m.received, m.status
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 139) AND (closed IS NULL OR (m.status = 'RSK' AND returned IS NULL))

END
GO
