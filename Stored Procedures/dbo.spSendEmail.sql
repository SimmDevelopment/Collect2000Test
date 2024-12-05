SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spSendEmail    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE PROCEDURE [dbo].[spSendEmail]
  @From varchar(100),
  @To varchar(100),
  @Subject varchar(100),
  @Body varchar(4000)
AS
  Declare @iMsg int
  Declare @hr int, @smtpserver varchar(100)

  SET @smtpserver='gssiweb1'

  EXEC @hr = sp_OACreate 'CDO.Message', @iMsg OUT
  EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value', '2' -- use remote SMTP server
  EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', @smtpserver
  EXEC @hr = sp_OAMethod @iMsg, 'Configuration.Fields.Update', null
  EXEC @hr = sp_OASetProperty @iMsg, 'To', @To
  EXEC @hr = sp_OASetProperty @iMsg, 'From', @From
  EXEC @hr = sp_OASetProperty @iMsg, 'Subject', @Subject
  EXEC @hr = sp_OASetProperty @iMsg, 'HTMLBody', @Body
  EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL
  EXEC @hr = sp_OADestroy @iMsg
GO
