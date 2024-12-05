SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewPODs    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewPODs]
  @number int
as 
  select CONVERT (varchar, invoicedate,107) as Date,custbranch as Branch,invoicenumber as [Invoice #],invoicedetail as 

Description,CONVERT(varchar(19), invoiceamount, 1) as Original,CONVERT(varchar(19), paidamt, 1) as Paid,CONVERT(varchar(19), currentamt, 1) as 

[Current] from PODDetail where number=@number
  order by invoicedate
GO
