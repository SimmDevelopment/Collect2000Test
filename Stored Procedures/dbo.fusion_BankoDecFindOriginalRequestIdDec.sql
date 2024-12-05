SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_BankoDecFindOriginalRequestIdDec]
	@newRequestId int
AS
BEGIN
	SET NOCOUNT ON;

	Declare @bankoManifestid uniqueidentifier 
	Declare @bankoServiceId int

	set @bankoManifestid='465E9424-AC3E-4D8B-9D2D-F233DB40CEDC'
	select @bankoServiceId = ServiceId from Services where Manifestid=@bankoManifestid

	Select top 1 RequestId 
	From ServiceHistory with (nolock) 
	Where RequestId != @newRequestId
	And Processed=101 and AcctId=(select AcctId from ServiceHistory where RequestId=@newRequestId) and ServiceId=@bankoServiceId

END
GO
