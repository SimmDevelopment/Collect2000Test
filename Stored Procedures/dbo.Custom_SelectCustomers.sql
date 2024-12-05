SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create  procedure [dbo].[Custom_SelectCustomers]
@startdate  datetime,
@stopdate datetime,
@customers text
AS

select 	customer,name,city,state,street1,street2,zipcode,contact,phone
from 	customer
where	dateupdated between @startdate and @stopdate



GO
