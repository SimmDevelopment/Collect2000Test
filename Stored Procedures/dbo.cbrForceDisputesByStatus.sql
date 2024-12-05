SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[cbrForceDisputesByStatus]
AS
	BEGIN
		--obtain all accounts that are in a dispute status

		if not OBJECT_ID('tempdb..#dispaccts') IS NULL drop table #dispaccts;

		select m.number into #dispaccts from master m
		inner join status s on s.code = m.status
		where s.isdisputed = 1;

		--obtain target accounts to be updated

		if not OBJECT_ID('tempdb..#updaccts') IS NULL drop table #updaccts;

		with histo as (
		select h.accountid as number from cbrAccountHistory(null) h  
		where ISNULL(h.complianceCondition,'') = '')
		select histo.number into #updaccts from histo inner join #dispaccts a on histo.number = a.number;

		--update cbr_accounts

		update cbr_accounts set complianceCondition = 'XB', lastUpdated = GETDATE() 
		where accountID in (Select number from #updaccts) 
		and isnull(complianceCondition,'') = '';
		
		;
	END 


GO
