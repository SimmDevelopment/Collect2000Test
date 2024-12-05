SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spDeleteUser    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE PROC [dbo].[spDeleteUser]
  @username varchar(15)
AS
  delete from csusers where username=@username
GO
