SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Test_tabs] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT customer, SUM(original)
FROM master WITH (NOLOCK)
WHERE customer = '0000101'
GROUP BY customer

SELECT number, original
FROM master WITH (NOLOCK)
WHERE customer = '0000101'
END
GO
