SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Recall_Confirmation_DN2] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT id1 AS data_id, (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number) AS placedetail_status, dbo.date(getdate()) AS status_date
FROM master m WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280)) AND returned = dbo.date(GETDATE())
and id2 not in ('AllGate','ARS-JMET')

END
GO
