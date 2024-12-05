SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spAddActivity    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE procedure [dbo].[spAddActivity]
	@username varchar(15),
             @number int,
	@description varchar(8000)
as 
  set nocount on
  DECLARE @userid int, @audituser smallint
  select @userid=userid,@audituser=audituser from csusers where username=@username
  if @audituser=1
    insert into csactivitylog (userid,number,description) values (@userid,@number,@description)
GO
