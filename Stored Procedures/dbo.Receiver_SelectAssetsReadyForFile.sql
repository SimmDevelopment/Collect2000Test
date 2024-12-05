SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Receiver_SelectAssetsReadyForFile]
@clientid int
AS
BEGIN
	DECLARE @lastFileSentDT datetime
	SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(22,@clientid) --- TO DO Have to figure out what to pass to this function.

	/*<column name="record_type" dataType="string" width="4" />
	<column name="debtor_number" dataType="int" width="9" />
	<column name="file_number" dataType="int" width="9" />
	<column name="asset_id" dataType="int" width="9" />
	<column name="asset_type_id" dataType="int" width="9" />
	<column name="asset_name" dataType="string" width="50" />
	<column name="asset_description" dataType="string" width="200" />
	<column name="asset_value" dataType="decimal" width="12" />
	<column name="asset_lien_value" dataType="decimal" width="12" />
	<column name="asset_value_verified_flag" dataType="string" width ="1" />
	<column name="asset_lien_value_verified_flag" dataType="string" width ="1" />*/

	SELECT 'AAST' as record_type,
	r.[SenderNumber] as file_number,
	rd.[SenderDebtorID] as debtor_number,
	CASE WHEN da.[CreatedBy] IN ('AIM') THEN da.[OutsideAssetID] ELSE da.[ID] END as asset_id,
	da.[AssetType] as asset_type_id,
	da.[Name] as asset_name,
	da.[Description] as asset_description,
	da.[CurrentValue] as asset_value,
	da.[LienAmount] as asset_lien_value,
	CASE da.[ValueVerified] WHEN 1 THEN 'T' ELSE 'F' END as asset_value_verified_flag,
	CASE da.[LienVerified] WHEN 1 THEN 'T' ELSE 'F' END as asset_lien_value_verified_flag
	FROM [dbo].[Debtor_Assets] da WITH (NOLOCK)
	INNER JOIN [dbo].[receiver_reference] r WITH (NOLOCK)
	ON da.[AccountID] = r.[ReceiverNumber]
	INNER JOIN [dbo].[receiver_debtorreference] rd WITH (NOLOCK)
	ON da.[DebtorID] = rd.[ReceiverDebtorID]
	WHERE ((da.Created > @lastFileSentDT AND da.[CreatedBy] != 'AIM') OR
		  (da.Modified > @lastFileSentDT AND da.[ModifiedBy] != 'AIM'))
	AND r.[ClientID] = @clientid AND rd.[ClientID] = @clientid
END
GO
