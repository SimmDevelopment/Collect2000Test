SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewSystemActivity    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewSystemActivity]
as 
  select CONVERT (varchar, Created,100) as Date,username,lower(Name) as Name,Account,Description from csactivitylog
    left join master on master.number=csactivitylog.number
    inner join csusers on csusers.userid=csactivitylog.userid
    order by created
GO
