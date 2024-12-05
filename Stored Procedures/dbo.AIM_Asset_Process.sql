SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Asset_Process]
@agencyId INT,
@file_number INT,
@debtor_number INT,
@asset_id INT,
@asset_type_id INT,
@asset_name VARCHAR(50),
@asset_description VARCHAR(200),
@asset_value MONEY,
@asset_lien_value MONEY,
@asset_value_verified_flag CHAR(1),
@asset_lien_value_verified_flag CHAR(1)


AS
BEGIN
DECLARE @masterNumber INT,@currentAgencyId INT,@debtorID INT
SELECT @masterNumber = m.Number,@currentAgencyId = m.AIMAgency,@debtorID = d.DebtorID
FROM dbo.master m WITH (NOLOCK) JOIN Debtors d WITH (NOLOCK) ON m.Number = d.Number WHERE m.Number = @file_number AND d.DebtorID = @debtor_number
--validate account exists and placed with this agency
IF(@masterNumber IS NULL)
BEGIN
	RAISERROR('15001',16,1)
	RETURN
END
-- Changed by KAR on 05/12/2011 SEnd 15004	The account is currently not placed with this agency
IF(@currentAgencyId IS NULL OR (@currentAgencyId <> @agencyId))
BEGIN
	RAISERROR('15004',16,1)
	RETURN
END

IF(@asset_id IS NOT NULL 
	AND EXISTS(SELECT * FROM Debtor_Assets WITH (NOLOCK) WHERE ID = @asset_id)
	)
BEGIN
--Update from Agency by AssetID as the asset originated in Latitude
UPDATE Debtor_Assets
SET
[AssetType] = CASE WHEN ISNULL(@asset_type_id,0) <= 9 THEN ISNULL(@asset_type_id,0) ELSE 0 END,
Modified = GETDATE(),
ModifiedBy = 'AIM',
[Name] = @asset_name,
[Description] = @asset_description,
[CurrentValue] = @asset_value,
[LienAmount] = @asset_lien_value,
[ValueVerified] = CASE @asset_value_verified_flag WHEN 'T' THEN 1 ELSE 0 END,
[LienVerified] = CASE @asset_lien_value_verified_flag WHEN 'T' THEN 1 ELSE 0 END

WHERE
ID = @asset_ID

END
ELSE IF(@asset_id IS NOT NULL 
		AND EXISTS(SELECT * FROM Debtor_Assets WITH (NOLOCK) WHERE OutsideAssetID = @asset_id AND CreatedBy = 'AIM')
		)
BEGIN
--Update from Agency as they initially created the record
UPDATE Debtor_Assets
SET
[AssetType] = CASE WHEN ISNULL(@asset_type_id,0) <= 9 THEN ISNULL(@asset_type_id,0) ELSE 0 END,
Modified = GETDATE(),
ModifiedBy = 'AIM',
[Name] = @asset_name,
[Description] = @asset_description,
[CurrentValue] = @asset_value,
[LienAmount] = @asset_lien_value,
[ValueVerified] = CASE @asset_value_verified_flag WHEN 'T' THEN 1 ELSE 0 END,
[LienVerified] = CASE @asset_lien_value_verified_flag WHEN 'T' THEN 1 ELSE 0 END

WHERE
DebtorID = @debtor_number AND OutsideAssetID = @asset_id

END
ELSE
BEGIN
--Insert new record from Agency
INSERT INTO [dbo].[Debtor_Assets]
           ([AccountID]
           ,[DebtorID]
           ,[Name]
           ,[AssetType]
           ,[Description]
           ,[CurrentValue]
           ,[LienAmount]
           ,[ValueVerified]
           ,[LienVerified]
           ,[Created]
		   ,[CreatedBy]
           ,[Modified]
           ,[ModifiedBy]
		   ,[OutsideAssetID])
     VALUES
           (@file_number
           ,@debtor_number
           ,@asset_name
           ,CASE WHEN ISNULL(@asset_type_id,0) <= 9 THEN ISNULL(@asset_type_id,0) ELSE 0 END
           ,@asset_description
           ,@asset_value
           ,@asset_lien_value
           ,CASE @asset_value_verified_flag WHEN 'T' THEN 1 ELSE 0 END
           ,CASE @asset_lien_value_verified_flag WHEN 'T' THEN 1 ELSE 0 END
           ,GETDATE()
		   ,'AIM'	
           ,GETDATE()
           ,'AIM'
		   ,@asset_id
           )
        
END

END

GO
