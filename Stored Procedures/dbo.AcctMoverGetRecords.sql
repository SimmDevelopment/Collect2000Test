SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*AcctMoverGetRecords*/
CREATE PROCEDURE [dbo].[AcctMoverGetRecords]
	@BasicQuery varchar(4000),
	@LinkMode tinyint

AS

 /*
**Name		:AcctMoverGetRecords
**Function	:Returns a recordset of accounts to be moved by GSSMover
**Creation	:4/14/2004 mr
**Used by 	:GSSMover.Job class
**Parameters:
**	@LinkMode = 0  Do not select any linked account
**	@LinkMode = 1  Select only the linked accounts in the Basic Query
**	@LinkMode = 2  Select all linked accounts to any linked account in the Basic Query
**Change History:
*/

Create Table #AcctMoverTemp(Number int)

SET NOCOUNT ON

Execute ('Insert Into #AcctMoverTemp(Number) ' + @BasicQuery)


If @LinkMode = 0 
	select Number, 0 as IsLink, 1 as TheCount, Current0 as Amount from 
	master Where number in (Select number from #AcctMoverTemp) and (Link is Null or Link = 0)
	order by Current0 desc
If @LinkMode = 1
	select Number, 0 as IsLink, 1 as TheCount, Current0 as Amount from
	master Where number in (Select number from #AcctMoverTemp)
	order by Current0 desc
If @LinkMode = 2
	(select Number, 0 as IsLink, 1 as TheCount, Current0 as Amount from
	master Where number in (Select number from #AcctMoverTemp) and (Link is Null or Link = 0)
	Union
	select Link as Number, 1 as IsLink, count(*) as TheCount, sum(current0) as Amount
	from master where Link in (Select Link from master where number in
					(Select number from #AcctMoverTemp) and Link > 0)
	Group by Link)
	order by Amount desc
GO
