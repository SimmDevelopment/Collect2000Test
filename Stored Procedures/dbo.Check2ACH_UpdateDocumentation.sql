SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Check2ACH_UpdateDocumentation]
@number int,
@guid varchar(36),
@image image,
@thumbnail image,
@filename varchar(260),
@username varchar(10),
@filesize int
AS
DECLARE @newguid uniqueidentifier
SET @newguid = newid()
INSERT INTO Documentation
(UID,CreatedDate,FileName,FileSize,SHA1Hash,Extension,[Image],Thumbnail,Location)
VALUES
(@newguid,getdate(),@filename,@filesize,@thumbnail,'.TIF',@image,@thumbnail,null)


INSERT INTO Documentation_Attachments
(AccountID,DocumentID,Name,[Index],AttachedDate,AttachedBy,Category)
VALUES
(@number,@newguid,'Scanned Check ' + cast(getdate() as varchar),1,getdate(),@username,'')


GO
