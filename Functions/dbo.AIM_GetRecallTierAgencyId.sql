SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     FUNCTION [dbo].[AIM_GetRecallTierAgencyId]
	(
		@accountReferenceId int, @tier int, @availableforsametier int
	)
returns int
as
	begin

declare @tier1 int,@tier2 int,@tier3 int,@tier4 int,@tier5 int,@tier6 int,@tier7 int,@tier8 int,@tier9 int
declare @tier10 int,@tier11 int,@tier12 int,@tier13 int,@tier14 int,@tier15 int
select	@tier1=ar.tier1,@tier2=ar.tier2,@tier3=ar.tier3,@tier4=ar.tier4,@tier5=ar.tier5,@tier6=ar.tier6,
		@tier7=ar.tier7,@tier8=ar.tier8,@tier9=ar.tier9,@tier10=ar.tier10,@tier11=ar.tier11,@tier12=ar.tier12,
		@tier13=ar.tier13,@tier14=ar.tier14,@tier15=ar.tier15
from	AIM_accountreference ar with(nolock)
where	accountReferenceId = @accountReferenceId

if(@tier = 1)
begin
	if(@availableforsametier = 1 and @tier2 is null)
		return null
	else
		return @tier1
end
else if(@tier = 2)
begin
	if(@availableforsametier = 1 and @tier3 is null)
		return null
	else
		return @tier2
end
else if(@tier = 3)
begin
	if(@availableforsametier = 1 and @tier4 is null)
		return null
	else
		return @tier3
end
else if(@tier = 4)
begin
	if(@availableforsametier = 1 and @tier5 is null)
		return null
	else
		return @tier4
end
else if(@tier = 5)
begin
	if(@availableforsametier = 1 and @tier6 is null)
		return null
	else
		return @tier5
end
else if(@tier = 6)
begin
	if(@availableforsametier = 1 and @tier7 is null)
		return null
	else
		return @tier6
end
else if(@tier = 7)
begin
	if(@availableforsametier = 1 and @tier8 is null)
		return null
	else
		return @tier7
end
else if(@tier = 8)
begin
	if(@availableforsametier = 1 and @tier9 is null)
		return null
	else
		return @tier8
end
else if(@tier = 9)
begin
	if(@availableforsametier = 1 and @tier10 is null)
		return null
	else
		return @tier9
end
else if(@tier = 10)
begin
	if(@availableforsametier = 1 and @tier11 is null)
		return null
	else
		return @tier10
end
else if(@tier = 11)
begin
	if(@availableforsametier = 1 and @tier12 is null)
		return null
	else
		return @tier11
end
else if(@tier = 12)
begin
	if(@availableforsametier = 1 and @tier13 is null)
		return null
	else
		return @tier12
end
else if(@tier = 13)
begin
	if(@availableforsametier = 1 and @tier14 is null)
		return null
	else
		return @tier13
end
else if(@tier = 14)
begin
	if(@availableforsametier = 1 and @tier15 is null)
		return null
	else
		return @tier14
end
else if(@tier = 15)
begin
	if(@availableforsametier = 1)
		return null
	else
		return @tier15
end
		
return null

end


GO
