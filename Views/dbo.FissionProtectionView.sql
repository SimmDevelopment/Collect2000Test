SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[FissionProtectionView]
AS
SELECT     ID, LocalPublicKey, LocalPrivateKey, LocalPassphrase, ThirdPartyPublicKey
FROM         dbo.Protection

GO
