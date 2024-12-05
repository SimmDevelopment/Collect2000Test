SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[CbrReportableAccounts] as
      select	c.customer,s.cbrreport,s.cbrdelete,s.code,count(*) as accts
      from		dbo.cbr_effectiveconfiguration cf
				inner join dbo.customer c on c.ccustomerid = cf.customerid
				inner join dbo.master m on m.customer = c.customer
				inner join dbo.status s on s.code = m.status
      where		cf.enabled = 1 and (s.cbrreport=1 or s.cbrdelete=1)
	  group by 
				c.customer,s.cbrreport,s.cbrdelete,s.code

GO
