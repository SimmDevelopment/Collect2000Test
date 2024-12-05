SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Open_Inventory] 
		@customer VARCHAR(8000)
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account AS [Account #],status + ' - ' + UPPER(s.Description) as [Status]
From master m with (nolock) INNER JOIN status s WITH (NOLOCK) ON m.STATUS = s.code
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|'))AND closed IS null
	
	
END
GO
