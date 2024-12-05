SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     FUNCTION [dbo].[AIM_GetTierPlacementDate]
	(
		@accountReferenceId int, @tier int, @currentdate datetime
	)
returns dateTime
as
	begin



declare @tier1 dateTime,@tier2 dateTime,@tier3 dateTime,@tier4 dateTime,@tier5 dateTime,@tier6 dateTime,@tier7 dateTime,@tier8 dateTime,@tier9 dateTime
declare @tier10 dateTime,@tier11 dateTime,@tier12 dateTime,@tier13 dateTime,@tier14 dateTime,@tier15 dateTime
select	@tier1=ar.tier1placementdate,@tier2=ar.tier2placementdate,@tier3=ar.tier3placementdate,@tier4=ar.tier4placementdate,@tier5=ar.tier5placementdate,@tier6=ar.tier6placementdate,
		@tier7=ar.tier7placementdate,@tier8=ar.tier8placementdate,@tier9=ar.tier9placementdate,@tier10=ar.tier10placementdate,@tier11=ar.tier11placementdate,@tier12=ar.tier12placementdate,
		@tier13=ar.tier13placementdate,@tier14=ar.tier14placementdate,@tier15=ar.tier15placementdate
from	AIM_accountreference ar with(nolock)
where	accountReferenceId = @accountReferenceId

if(@tier = 1)
begin
	if(@tier1 is null)
		return @currentdate
	else
		return @tier1
end
else if(@tier = 2)
begin
	if(@tier1 is not null)
		return @currentdate
	else
		return @tier2
end
else if(@tier = 3)
begin
	if(@tier2 is not null)
		return @currentdate
	else
		return @tier3
end
else if(@tier = 4)
begin
	if(@tier3 is not null)
		return @currentdate
	else
		return @tier4
end
else if(@tier = 5)
begin
	if(@tier4 is not null)
		return @currentdate
	else
		return @tier5
end
else if(@tier = 6)
begin
	if(@tier5 is not null)
		return @currentdate
	else
		return @tier6
end
else if(@tier = 7)
begin
	if(@tier6 is not null)
		return @currentdate
	else
		return @tier7
end
else if(@tier = 8)
begin
	if(@tier7 is not null)
		return @currentdate
	else
		return @tier8
end
else if(@tier = 9)
begin
	if(@tier8 is not null)
		return @currentdate
	else
		return @tier9
end
else if(@tier = 10)
begin
	if(@tier9 is not null)
		return @currentdate
	else
		return @tier10
end
else if(@tier = 11)
begin
	if(@tier10 is not null)
		return @currentdate
	else
		return @tier11
end
else if(@tier = 12)
begin
	if(@tier11 is not null)
		return @currentdate
	else
		return @tier12
end
else if(@tier = 13)
begin
	if(@tier12 is not null)
		return @currentdate
	else
		return @tier13
end
else if(@tier = 14)
begin
	if(@tier13 is not null)
		return @currentdate
	else
		return @tier14
end
else if(@tier = 15)
begin
	if(@tier14 is not null)
		return @currentdate
	else
		return @tier15
end
		
return null

end


GO
