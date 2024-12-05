SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Fission_GetPackageConfigById]
(
	@packageId int
)
AS
	SET NOCOUNT ON;
SELECT     ServiceID, 
Description, 
Enabled, 
Email, 
MinBalance, 
ManifestID, 
--TransferTypeID, 
Policy, 
--Config, 
--ThirdPartyKeyRing, 
--LocalKeyRing, 
PackageID, 
Template,
TransferID,
ProtectionID,
QueryID
FROM         FissionPackageConfigView
WHERE     (PackageID = @packageId)


GO
