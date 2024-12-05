SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[Custom_NCO_Tert_Risk_Report] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT number, m.account, received, status
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001283', '0001404') AND status = 'RSK' AND dbo.date(closed) = dbo.date(GETDATE()) 

END
GO
