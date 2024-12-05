SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Custom_BB&T_Active_Inventory] 
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(5000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account as [Account Number],current1 + current2 AS [Current Balance], Name as [Client Name]
FROM master WITH (NOLOCK)
WHERE customer IN (select string from dbo.CustomStringToSet(@customer,'|')) AND closed IS null

END
GO
