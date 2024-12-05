SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewCustomers    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE procedure [dbo].[spViewCustomers]
  @username varchar(15)
as 
  declare @userid int
  set @userid = (select userid from csusers where username=@username)
  
  select customer from customer
    where custgroup in (select customer from csusercustomers where userid=@userid)
      or customer in (select  customer from csusercustomers where userid=@userid)
GO
