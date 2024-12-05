SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[cbrDataPaidByInsurance]
as

	select accountid, debtorid, 'Pending Delete' as acctstate from cbrDataPendingDtlex(null)  where specialnote = 'DI' and creditorclass = '02' and racctstat in ('62','64')
	union all
	select accountid, debtorid, 'Reported Delete' as acctstate from cbrDataPendingDtlex(null)  where specialnote = 'DI' and creditorclass = '02' and racctstat in ('DA','DF')

GO
