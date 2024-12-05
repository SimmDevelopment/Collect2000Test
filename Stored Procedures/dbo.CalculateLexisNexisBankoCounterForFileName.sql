SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE  [dbo].[CalculateLexisNexisBankoCounterForFileName] 

@PackageID int

AS

--DECLARE @PackageID int
--SET @PackageID = 18
DECLARE @Counter int
SET @Counter = 0
DECLARE @ManifestID uniqueidentifier
SELECT @ManifestID = S.ManifestID FROM Services S JOIN Fusion_Packages fp
ON fp.ServiceID = S.ServiceID WHERE fp.ID = @PackageID

IF (@ManifestID in ('366A78FA-62A6-410D-ABEE-A3E71E165073','465E9424-AC3E-4D8B-9D2D-F233DB40CEDC'))
BEGIN
	SELECT @Counter = count(*)

	FROM ServiceBatch_Requests sbr WITH (NOLOCK) JOIN Services S WITH (NOLOCK)
	ON sbr.ServiceID = S.ServiceID 

	WHERE sbr.PackageID is not null AND S.ManifestID in ('366A78FA-62A6-410D-ABEE-A3E71E165073','465E9424-AC3E-4D8B-9D2D-F233DB40CEDC')
	AND convert(varchar(8),getdate(),112) = convert(varchar(8),sbr.daterequested,112)

END
ELSE
BEGIN
	SELECT @Counter = count(*)

	FROM ServiceBatch_Requests sbr WITH (NOLOCK) JOIN Services S WITH (NOLOCK)
	ON sbr.ServiceID = S.ServiceID 

	WHERE sbr.PackageID is not null AND S.ManifestID = @ManifestID
	AND convert(varchar(8),getdate(),112) = convert(varchar(8),sbr.daterequested,112)



END



SELECT @Counter+1 as [DayCounter]



GO
