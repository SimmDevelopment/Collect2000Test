SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[FissionPackageConfigView]
AS
SELECT     dbo.Services.ServiceId, dbo.Services.Description, dbo.Services.Enabled, dbo.Services.Email, dbo.Services.MinBalance, dbo.Services.ManifestID, 
                      dbo.Fusion_Packages.ID AS PackageID, dbo.Fusion_Packages.Policy, dbo.Services.Template, dbo.Fusion_Packages.ProtectionID, 
                      dbo.Fusion_Packages.TransferID, dbo.Fusion_Packages.QueryID
FROM         dbo.Services INNER JOIN
                      dbo.Fusion_Packages ON dbo.Services.ServiceId = dbo.Fusion_Packages.ServiceID

GO
