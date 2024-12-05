SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Update_BatchFileHistoryEmailandFTPInfo]
@batchfilehistoryid int,
@FTPSuccess bit,
@EmailSuccess bit,
@ftpMessage text,
@emailMessage text

AS

Update AIM_BatchFileHistory
SET
FTPSuccess = @FTPSuccess,
EmailSuccess = @EmailSuccess,
FTPMessage = @ftpMessage,
EmailMessage = @emailMessage
WHERE BatchFileHistoryId = @batchfilehistoryid


GO
