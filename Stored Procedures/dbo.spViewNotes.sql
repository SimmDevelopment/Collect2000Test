SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewNotes    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewNotes]
  @number int
as 
  select CONVERT (varchar, created,100)  as Date,user0 as Desk,[action] as Action,result as Result,comment as Comment from notes where 

number=@number
  order by created
GO
