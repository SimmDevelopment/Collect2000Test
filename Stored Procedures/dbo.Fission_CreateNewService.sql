SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Fission_CreateNewService]
(
	@Template text,
	@manifestId uniqueidentifier
)
AS
	SET NOCOUNT OFF;
UPDATE    Services
SET              Template = @Template
WHERE	  ManifestID=@manifestId

GO
