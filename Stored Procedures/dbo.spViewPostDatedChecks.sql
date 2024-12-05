SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewPostDatedChecks    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewPostDatedChecks]
  @number int
as 
  select CONVERT (varchar, entered,107)  as Entered,onhold as [On Hold],CONVERT (varchar, deposit,107)  as [Deposit Date],CONVERT(varchar(19), 

amount, 1) as Amount,processed1 as Processed,checknbr as [Check #],nitd as [Nitd Sent] from pdc where number=@number
GO
