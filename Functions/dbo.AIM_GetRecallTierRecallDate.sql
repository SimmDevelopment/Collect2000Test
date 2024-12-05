SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     FUNCTION [dbo].[AIM_GetRecallTierRecallDate]
	(
		@accountReferenceId int, @tier int, @availableforsametier int, @currentdate datetime
	)
returns dateTime
as
	begin

declare @tier1 dateTime,@tier2 dateTime,@tier3 dateTime,@tier4 dateTime,@tier5 dateTime,@tier6 dateTime,@tier7 dateTime,@tier8 dateTime,@tier9 dateTime
declare @tier10 dateTime,@tier11 dateTime,@tier12 dateTime,@tier13 dateTime,@tier14 dateTime,@tier15 dateTime
select	@tier1=ar.tier1recalldate,@tier2=ar.tier2recalldate,@tier3=ar.tier3recalldate,@tier4=ar.tier4recalldate,@tier5=ar.tier5recalldate,@tier6=ar.tier6recalldate,
		@tier7=ar.tier7recalldate,@tier8=ar.tier8recalldate,@tier9=ar.tier9recalldate,@tier10=ar.tier10recalldate,@tier11=ar.tier11recalldate,@tier12=ar.tier12recalldate,
		@tier13=ar.tier13recalldate,@tier14=ar.tier14recalldate,@tier15=ar.tier15recalldate
from	AIM_accountreference ar with(nolock)
where	accountReferenceId = @accountReferenceId

if(@tier = 1)
begin
	if(@availableforsametier = 1 and @tier2 is null)
		return null
	else if (@tier1 is null)
		return @currentdate
	else
		return @tier1
end
else if(@tier = 2)
begin
	if(@availableforsametier = 1 and @tier3 is null)
		return null
	else if (@tier2 is not null)
		return @currentdate
	else
		return @tier2
end
else if(@tier = 3)
begin
	if(@availableforsametier = 1 and @tier4 is null)
		return null
	else if (@tier3 is not null)
		return @currentdate
	else
		return @tier3
end
else if(@tier = 4)
begin
	if(@availableforsametier = 1 and @tier5 is null)
		return null
	else if (@tier4 is not null)
		return @currentdate
	else
		return @tier4
end
else if(@tier = 5)
begin
	if(@availableforsametier = 1 and @tier6 is null)
		return null
	else if (@tier5 is not null)
		return @currentdate
	else
		return @tier5
end
else if(@tier = 6)
begin
	if(@availableforsametier = 1 and @tier7 is null)
		return null
	else if (@tier6 is not null)
		return @currentdate
	else
		return @tier6
end
else if(@tier = 7)
begin
	if(@availableforsametier = 1 and @tier8 is null)
		return null
	else if (@tier7 is not null)
		return @currentdate
	else
		return @tier7
end
else if(@tier = 8)
begin
	if(@availableforsametier = 1 and @tier9 is null)
		return null
	else if (@tier8 is not null)
		return @currentdate
	else
		return @tier8
end
else if(@tier = 9)
begin
	if(@availableforsametier = 1 and @tier10 is null)
		return null
	else if (@tier9 is not null)
		return @currentdate
	else
		return @tier9
end
else if(@tier = 10)
begin
	if(@availableforsametier = 1 and @tier11 is null)
		return null
	else if (@tier10 is not null)
		return @currentdate
	else
		return @tier10
end
else if(@tier = 11)
begin
	if(@availableforsametier = 1 and @tier12 is null)
		return null
	else if (@tier11 is not null)
		return @currentdate
	else
		return @tier11
end
else if(@tier = 12)
begin
	if(@availableforsametier = 1 and @tier13 is null)
		return null
	else if (@tier12 is not null)
		return @currentdate
	else
		return @tier12
end
else if(@tier = 13)
begin
	if(@availableforsametier = 1 and @tier14 is null)
		return null
	else if (@tier13 is not null)
		return @currentdate
	else
		return @tier13
end
else if(@tier = 14)
begin
	if(@availableforsametier = 1 and @tier15 is null)
		return null
	else if (@tier14 is not null)
		return @currentdate
	else
		return @tier14
end
else if(@tier = 15)
begin
	if(@availableforsametier = 1 )
		return null
	else if (@tier15 is not null)
		return @currentdate
	else
		return @tier15
end
		
return null

end



GO
