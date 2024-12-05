SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewUserActivity    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewUserActivity]
  @username varchar(15)
as 
  DECLARE @userid int
  SET @userid=(select userid from csusers where username=@username)
  select CONVERT (varchar, Created,100) as Date,lower(Name) as Name,Account,Description from csactivitylog
    left join master on master.number=csactivitylog.number
    where userid=@userid
    order by created
GO
