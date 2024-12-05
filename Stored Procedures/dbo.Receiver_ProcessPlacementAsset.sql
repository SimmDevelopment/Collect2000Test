SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessPlacementAsset]
@client_id int,
@debtor_number int,
@file_number int,
@asset_id int,
@asset_type_id int,
@asset_name varchar (50),
@asset_description varchar(4000),
@asset_value money,
@asset_lien_value money,
@asset_value_verified_flag varchar(1),
@asset_lien_value_verified_flag  varchar(1)
AS
BEGIN
	DECLARE @receiverNumber INT
	
	SELECT @receivernumber = max(receivernumber)
	FROM receiver_reference WITH (NOLOCK) 
	WHERE sendernumber = @file_number and clientid = @client_id
	
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END
	
	DECLARE @dnumber int
	select @dnumber = max(receiverdebtorid )
	from receiver_debtorreference rd with (nolock)
	join debtors d with (nolock) on rd.receiverdebtorid = d.debtorid
	where senderdebtorid = @debtor_number
	and clientid = @client_id

	IF(@dnumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1) -- TODO Which error to raise here?
		RETURN
	END

	INSERT INTO [dbo].[Debtor_Assets]
	([AccountID],
	[DebtorID],
	[Name],
	[AssetType], -- Will need to get this somehow from AIM.
	[Description],
	[CurrentValue],
	[LienAmount],
	[ValueVerified],
	[LienVerified],
	[ModifiedBy],
	[CreatedBy],
	[OutsideAssetID])
	VALUES
	(@receiverNumber,
	@dNumber,
	@asset_name,
	CASE WHEN @asset_type_id IN (0,1,2,3,4,5,6,7,8,9) THEN @asset_type_id ELSE 0 END,
	@asset_description,
	@asset_value,
	@asset_lien_value,
	CASE WHEN @asset_value_verified_flag IN ('1','Y','T') THEN 1 ELSE 0 END,
	CASE WHEN @asset_lien_value_verified_flag IN ('1','Y','T') THEN 1 ELSE 0 END,
	'AIM',
	'AIM',
	@asset_id
	)
END
GO
