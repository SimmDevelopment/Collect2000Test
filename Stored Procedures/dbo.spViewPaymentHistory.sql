SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewPaymentHistory    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewPaymentHistory]
  @number int
as 
  select UID,CONVERT (varchar, entered,107)  as Entered,CONVERT (varchar, datepaid,107) as [Date Paid],CONVERT(varchar(19), totalpaid, 1) as 

[Total Paid],paytype as [Pay Type],paymethod as [Pay Method],CONVERT (varchar, invoiced,107)  as [Invoiced On],checknbr as [Check 

#],Comment+'&nbsp;' as Comment,batchnumber as [Batch #] from payhistory where number=@number
  order by entered
GO
