SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GoldenTree_Update_Recall_Dates] 
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
	SET closed = dbo.date(@date), returned = dbo.date(@date) --Actual Recall Date
	WHERE customer in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 204 AND customerid <> '0001360') 
	AND dbo.date(returned) = dbo.date(GETDATE()) --Monday's Date

	
	END
END
GO
