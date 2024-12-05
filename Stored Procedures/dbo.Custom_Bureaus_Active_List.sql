SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Bureaus_Active_List]


 AS

select received as [Date Placed], id2 as file_number, number as [Agency Account Number], account as [Original Number], originalcreditor as [Original Creditor], homephone as Home_number, workphone as Work_number, street1 as _street1, street2 as _street2, city as _city, state as _state, zipcode as _zipcode, worked as date_updated, mr as [Mail Return Y/N], current0 as [Current balance],original as [Principal balance], lastpaid as[Last Paid Date], lastpaidamt as [Last Payment Amount], InterestRate as [Interest Rate], Paid1 as [Total Paid], status as [Agency Status]
from master with (nolock)
where customer = '0000993' and status in (select code from status with (nolock) where statustype = '0 - active')
GO
