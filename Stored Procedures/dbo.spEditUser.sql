SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spEditUser    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE PROC [dbo].[spEditUser]
  @username varchar(15), @email varchar(255), @supervisoremail varchar(255), @notifyemail varchar(255),
  @firstname varchar(25), @lastname varchar(25), @superuser smallint, @disabled smallint, @audituser smallint, @permissionlist varchar(8000), 

@customerlist varchar(8000)
AS
  DECLARE @userid int

  update csusers 
    set username=@username,email=@email,supervisoremail=@supervisoremail,notifyemail=@notifyemail,
          firstname=@firstname,lastname=@lastname,superuser=@superuser,disabled=@disabled, audituser=@audituser
    where username=@username

  IF @permissionlist<>''
    EXECUTE ('update csusers set '+@permissionlist+' where username='''+@username+'''')

  IF @customerlist<>''
  BEGIN
    SET @userid=(select userid from csusers where username=@username)
    delete from csusercustomers where userid=@userid
    insert into csusercustomers
      select @userid as userid,string as customer from StringToSet(@customerlist,',')
  END
GO
