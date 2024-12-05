SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewUsersOnline    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewUsersOnline]
  @current bit
as 
  if @current=1
    select '<a href="#" onclick="showActivity()">'+substring(description,6,charindex(' logged in',description)-6)+'</a>' as [User],Created as 

[Login Date] from csactivitylog where description like '% logged in' and datediff(minute,created,getdate()) < 60
    order by Created
  else
    select '<a href="#" onclick="showActivity()">'+substring(description,6,charindex(' logged in',description)-6)+'</a>' as [User],Created as 

[Login Date] from csactivitylog where description like '% logged in' and datediff(day,created,getdate()) = 0
    order by Created
GO
