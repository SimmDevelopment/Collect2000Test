SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[TempCnvBalSheet2] as
select	a.customer as Customer,
		
		sum(a.original) AS original, 
		sum(a.original1) AS original1,
		sum(a.original2) AS original2,
		sum(a.original5) as original5,
		sum(a.original6) as original6,
		sum(a.original7) as original7,
		sum(a.original9) as original9,

		sum(current0) as current0,

		sum(a.current1) as current1,
		sum(a.current2) as current2,
		sum(a.current5) as current5,
		sum(a.current6)  as current6,
		sum(a.current7) as current7,
		sum(a.current9) as current9

	--into #BalSheet2
  
	from cnvsimmnumber x
		inner join master a on a.number = x.number
	group by
		a.customer

GO
