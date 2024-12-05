SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[cbrForceDeletesByStatus]
AS
	BEGIN
		--obtain all accounts that are in a delete or fraud status

		if not OBJECT_ID('tempdb..#delaccts') IS NULL drop table #delaccts;

		select m.number,Case when s.CbrReport = 1 and s.cbrDelete = 1 then 'DA' when s.CbrReport = 1 and s.isfraud = 1 then 'DF' End as specialnote 
		into #delaccts 
		from master m
		inner join status s on s.code = m.status
		where s.CbrReport = 1 and (s.cbrDelete = 1 or s.IsFraud = 1) and isnull(m.specialnote,'') not in ('DA','DF');

		--update master

		update master set specialnote = d.specialnote from #delaccts d inner join master m on d.number = m.number
		;
	END 


GO
