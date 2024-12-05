SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Fission_GetTransferById]
(
	@transferId int
)
AS
	SET NOCOUNT ON;
SELECT     ID, Name, Description, TreePath, TransferTypeID, Username, Password, Host, Port, Passive, Explicit,  PickupMode, Overwrite, 
                      RegexDownloadFileExpression, RemoteDirectoryLocation, UploadFileExpression, LocalDirectoryLocation, RenameRemoteFileOnDownload, 
                      RenamedLocalFileExpression
FROM         FissionTransferView
WHERE     (ID = @transferId)


GO
