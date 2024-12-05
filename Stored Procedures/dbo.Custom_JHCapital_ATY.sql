SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_ATY]
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.Name, m.Account, 'Firm: ' + CASE WHEN a.firm = '' THEN 'N/A' ELSE a.firm  end + ' Atty: ' + a.name + ' ' + a.Addr1 + ' ' + a.City + ', ' + a.State + ' ' + a.Zipcode + ' Phone: ' + a.Phone AS [Attorney Info]
FROM master m WITH (NOLOCK) INNER JOIN dbo.DebtorAttorneys a WITH (NOLOCK) ON m.number = a.AccountID
WHERE customer IN (select customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID  in (186,280)) AND closed IS NULL
and id2 not in ('AllGate','ARS-JMET')

END
GO
