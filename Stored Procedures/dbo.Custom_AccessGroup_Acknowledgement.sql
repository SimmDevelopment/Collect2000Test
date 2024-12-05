SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AccessGroup_Acknowledgement] 
	-- Add the parameters for the stored procedure here
	@received datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT id1 AS [File Number], Name, Account, Received AS [Date Received], current1 + current2 + current3 + current4 + current5 AS [Placed Amount]
FROM master m WITH (NOLOCK)
WHERE customer = '0001039' AND received = @received

END
GO
