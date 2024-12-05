SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spGetCustomerCheckList    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE PROC [dbo].[spGetCustomerCheckList]
  @username varchar(15)
AS
  DECLARE @userid int
  SET @userid = (select userid from csusers where username=@username)

select customer,name,0 as checked
  from vCustGroups
  where customer not in (select customer from csusercustomers where userid=@userid)
union
select customer,name,1 as checked
  from vCustGroups
  where customer in (select customer from csusercustomers where userid=@userid)
GO
