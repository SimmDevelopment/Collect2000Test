SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Custom_GetServices]
AS

SELECT distinct ServiceId as [ServiceId], Description as [Description], ManifestId as [ManifestId]
FROM Services
WHERE ServiceID >0 and ManifestId is not null
GO
