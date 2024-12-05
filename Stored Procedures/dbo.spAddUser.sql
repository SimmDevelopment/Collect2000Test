SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spAddUser    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE PROC [dbo].[spAddUser]
  @username varchar(15), @password varchar(15), @email varchar(255), @supervisoremail varchar(255), @notifyemail varchar(255),
  @firstname varchar(25), @lastname varchar(25), @superuser smallint, @disabled smallint, @audituser smallint, @permissionlist varchar(8000), 

@customerlist varchar(8000)
AS
  DECLARE @error varchar(8000)
  if not exists(select username from csusers where username=@username)
    begin
      insert into csusers (username,password,email,supervisoremail,notifyemail,firstname,lastname,superuser,disabled,audituser)
        values (@username,CHECKSUM(@password),@email,@supervisoremail,@notifyemail,@firstname,@lastname,@superuser,@disabled, @audituser)
      IF @permissionlist<>''
        EXECUTE ('update csusers set '+@permissionlist+' where username='''+@username+'''')
      IF @customerlist<>''
        insert into csusercustomers
      select SCOPE_IDENTITY() as userid,string as customer from StringToSet(@customerlist,',')
    end
  else
    begin
      set @error='Username '+@username+' already exists.  Try again with another username.'
      raiserror (@error, 16, 1)
    end
GO
