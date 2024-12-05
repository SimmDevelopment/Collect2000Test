SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Fission_GetProtectionById]
(
	@protectionID int
)
AS
	SET NOCOUNT ON;
SELECT     ID, LocalPublicKey, LocalPrivateKey, LocalPassphrase, ThirdPartyPublicKey
FROM         FissionProtectionView
WHERE     (ID = @protectionID)

GO
