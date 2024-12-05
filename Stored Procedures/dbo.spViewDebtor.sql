SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewDebtor    Script Date: 4/11/2002 5:04:15 PM ******/
create procedure [dbo].[spViewDebtor]
  @number int
as 
  select * from vDebtorView where number=@number
GO
