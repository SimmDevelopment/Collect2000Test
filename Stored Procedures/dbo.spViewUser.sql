SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewUser    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewUser]
  @username varchar(15)
as 
  select * from csusers   where username=@username
GO
