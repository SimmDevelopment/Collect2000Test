SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   PROCEDURE [dbo].[sp_Custom_GenesisReconcileExport]
@customer varchar(8000)
AS
BEGIN
	
	SELECT 
	m.account as account,
	m.id2 as placementId,
	m.current0 as currentBalance,
	m.original as originalBalance,
	RTRIM(LTRIM(m.street1 + ' ' + RTRIM(LTRIM(m.street2))))as address,
	m.city as city,
	m.state as state,
	m.zipcode as zipCode,
	m.homephone as homePhone,
	'RC00' as status
	FROM master m WITH(NOLOCK)
	WHERE m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|')) AND
	m.Qlevel NOT IN('998','999')
	ORDER BY m.account
END



GO
