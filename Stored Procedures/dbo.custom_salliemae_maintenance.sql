SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[custom_salliemae_maintenance]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select dbo.date(getdate()) as Date, count(*) as numrecs
from master with (Nolock)
where customer = '0001004' and (number in (select accountid from addresshistory with (nolock) where dbo.date(datechanged) = dbo.date(getdate())) or dbo.date(contacted) = dbo.date(getdate()) or number in (select accountid from statushistory with (nolock) where dbo.date(datechanged) = dbo.date(getdate())))

select isnull(d1.ssn, '') as accountnumber, 
	isnull(d1.firstname, '') as primfirstname, 
	isnull(d1.lastname, '') as primlastname, 
	isnull(d1.ssn, '') as primssn, 
	isnull(d1.street1, '') as primstreet1, 
	isnull(d1.street2, '') as primstreet2, 
	isnull(d1.city, '') as primcity, 
	isnull(d1.state, '') as primstate, 
	isnull(d1.zipcode, '') as primzip, 
	isnull(d1.homephone, '') as primhomephone, 
	isnull(d1.jobname, '') as primpoename, 
	isnull(d1.workphone, '') as primpoephone, 
	isnull(d1.jobaddr1, '') as primpoeaddr1, 
	isnull(d1.jobcsz, '') as primcity, 
	isnull(d2.ssn, '') as codebt1ssn, 
	isnull(d2.firstname, '') as codebt1firstname, 
	isnull(d2.lastname, '') as codebt1lastname, 
	isnull(d2.homephone, '') as codebt1homephone, 
	isnull(d2.street1, '') as codebt1street1, 
	isnull(d2.city, '') as codebt1city, 
	isnull(d2.state, '') as codebt1state, 
	isnull(d2.zipcode, '') as codebt1zip, 
	isnull(d2.jobname, '') as codebt1poename, 
	isnull(d2.jobaddr1, '') as codebt1poeaddr1, 
	isnull(d2.jobcsz, '') as codebt1poecity, 
	isnull(d3.ssn, '') as codebt2ssn, 
	isnull(d3.firstname, '') as codebt2firstname, 
	isnull(d3.lastname, '') as codebt2lastname, 
	isnull(d3.homephone, '') as codebt2homephone, 
	isnull(d3.street1, '') as codebt2street1, 
	isnull(d3.city, '') as codebt2city, 
	isnull(d3.state, '') as codebt2state, 
	isnull(d3.zipcode, '') as codebt2zip, 
	isnull(d3.jobname, '') as codebt2poename, 
	isnull(d3.jobaddr1, '') as codebt2poeaddr1, 
	isnull(d3.jobcsz, '') as codebt2poecity, 
	isnull(id2, '') as arrowacctnumber, 
	contacted as lastcontact, 
	(select max(datechanged) from addresshistory with (nolock) where accountid = m.number) as addrchange, 
	isnull(status, '') as status
from master m with (nolock) inner join debtors d1 with (nolock) on m.number = d1.number and d1.seq = 0 left outer join debtors d2 with (nolock) on m.number = d2.number and d2.seq = 1 left outer join debtors d3 with (nolock) on m.number = d3.number and d3.seq = 2
where customer = '0001004' and (m.number in (select accountid from addresshistory with (nolock) where dbo.date(datechanged) = dbo.date(getdate())) or dbo.date(m.contacted) = dbo.date(getdate()) or m.number in (select accountid from statushistory with (nolock) where dbo.date(datechanged) = dbo.date(getdate())))
END
GO
