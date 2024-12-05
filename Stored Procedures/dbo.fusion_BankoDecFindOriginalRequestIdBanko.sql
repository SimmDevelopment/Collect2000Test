SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[fusion_BankoDecFindOriginalRequestIdBanko]
	@newRequestId int
AS
BEGIN
	SET NOCOUNT ON;

	Declare @bankoManifestid uniqueidentifier 
	Declare @bankoServiceId int

	set @bankoManifestid='366A78FA-62A6-410D-ABEE-A3E71E165073'
	select @bankoServiceId = ServiceId from Services where Manifestid=@bankoManifestid

	Select top 1 RequestId 
	From ServiceHistory with (nolock) 
	Where RequestId != @newRequestId
	And Processed=101 and AcctId=(select AcctId from ServiceHistory where RequestId=@newRequestId) and ServiceId=@bankoServiceId

END
GO
