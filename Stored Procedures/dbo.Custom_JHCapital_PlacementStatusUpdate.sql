SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_PlacementStatusUpdate]
	-- Add the parameters for the stored procedure here
	@received DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
   
 --added forw_acctno field 8/3/2016  BGM.
-- 7/17/2017 BGM Removed CASE WHEN m.customer = '0001295' THEN '191000' ELSE '111010' end  AS update_code, from first field
SELECT id1 AS data_id,  m.number AS forw_acctno --dbo.date(GETDATE()) AS status_date
	
FROM master m WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280)) AND dbo.date(received) = dbo.date(@received)

INSERT INTO dbo.Custom_JHCapital_Status_Codes
        ( DataID, StatusCode, statusdate )
        
SELECT id1 AS data_id, CASE WHEN m.customer = '0001295' THEN '191000' ELSE '111010' end  AS update_code, dbo.date(GETDATE()) AS status_date
	
FROM master m WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280)) AND dbo.date(received) = dbo.date(@received)
and id2 not in ('AllGate','ARS-JMET')

END
GO
