SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GoldenTree_Update_Received_Dates] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Golden tree update closed and returned dates
IF ((SELECT MAX(DateAdded)
FROM dbo.Custom_GoldenTree_Packet WITH (NOLOCK)) <> dbo.date(GETDATE()))
begin
	DECLARE @date DATETIME
	select @date = dbo.date(MAX(DateAdded))
	FROM dbo.Custom_GoldenTree_Packet WITH (NOLOCK)
	
	UPDATE master
	SET received = dbo.date(@date)
	WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 204 AND customerid <> '0001360') 
	AND dbo.date(received) = dbo.date(@date) --Monday's Date


	
	END
END
GO
