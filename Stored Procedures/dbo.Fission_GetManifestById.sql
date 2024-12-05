SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Fission_GetManifestById]
	@serviceId int
AS
BEGIN

	SELECT     ManifestID
	FROM         Services WITH (NOLOCK)
	WHERE     (ServiceId = @serviceId)

END


GO
