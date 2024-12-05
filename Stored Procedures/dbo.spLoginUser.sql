SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[spLoginUser]
  @username varchar(15), @password varchar(15)
AS
  DECLARE @realpassword int, @subject varchar(100),@body varchar(4000),@email varchar(255), @notifyemail varchar(255), @firstname varchar(25), @lastname varchar(25), @disabled int, @result varchar(15)
  select @realpassword=password, @firstname=firstname, @lastname=lastname, @disabled=disabled, @email=email, @notifyemail=notifyemail from csusers where username=@username

  IF @realpassword is null
    SET @result = 'notfound'
  ELSE
  BEGIN
    IF @realpassword=CHECKSUM(@password)
      IF @disabled=0
      BEGIN
        SET @result='ok'
        SET @subject='User '+@username+' logged in'
        SET @body='User '+@username + ' logged in.  '+CHAR(13)+CHAR(10)+'<p><p>(To deactivate this notification, empty the Notify Email field for this user.)'
        EXEC spSendEmail @notifyemail, @notifyemail,@subject,@body
        EXEC spAddActivity @username, 0, @subject
      END
      ELSE
        SET @result='disabled'
    ELSE
      SET @result='wrongpw'
  END
  IF @result='ok'
    SELECT @result as result,* from csusers where username=@username
  ELSE
    SELECT @result as result
GO
