SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Deceased_Update_DN2] 
	-- Add the parameters for the stored procedure here
	@startDate AS datetime,
	@endDate AS DATETIME
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1 as data_id,
'' AS dec_id,
d.dod AS dec_date,
'' AS dec_case,
'' AS dec_estate,
'' AS dec_estate_value,
'' AS dec_county,
'' AS dec_state,
'' AS dec_type,
'' AS dec_filing,
'' AS dec_alias,
'' AS dec_ssn,
'' AS probate_name,
'' AS probate_add1,
'' AS probate_add2,
'' AS probate_city,
'' AS probate_state,
'' AS probate_zip,
'' AS probate_company,
'' AS probate_wphone,
'' AS probate_wphone_ext

FROM master m WITH (NOLOCK) INNER JOIN Deceased d WITH (NOLOCK) ON m.number = d.AccountID
WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID  in (186,280)) AND (d.dod IS NOT NULL OR d.dod > '19000101')
AND d.TransmittedDate BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) and id2 not in ('AllGate','ARS-JMET')

END
GO
