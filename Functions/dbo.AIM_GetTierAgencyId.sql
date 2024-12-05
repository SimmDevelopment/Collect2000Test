SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     FUNCTION [dbo].[AIM_GetTierAgencyId]
	(
		@accountReferenceId int, @tier int, @agencyId int
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
	if(@tier1 is null)
		return @agencyId
	else
		return @tier1
end
else if(@tier = 2)
begin
	if(@tier1 is not null)
		return @agencyId
	else
		return @tier2
end
else if(@tier = 3)
begin
	if(@tier2 is not null)
		return @agencyId
	else
		return @tier3
end
else if(@tier = 4)
begin
	if(@tier3 is not null)
		return @agencyId
	else
		return @tier4
end
else if(@tier = 5)
begin
	if(@tier4 is not null)
		return @agencyId
	else
		return @tier5
end
else if(@tier = 6)
begin
	if(@tier5 is not null)
		return @agencyId
	else
		return @tier6
end
else if(@tier = 7)
begin
	if(@tier6 is not null)
		return @agencyId
	else
		return @tier7
end
else if(@tier = 8)
begin
	if(@tier7 is not null)
		return @agencyId
	else
		return @tier8
end
else if(@tier = 9)
begin
	if(@tier8 is not null)
		return @agencyId
	else
		return @tier9
end
else if(@tier = 10)
begin
	if(@tier9 is not null)
		return @agencyId
	else
		return @tier10
end
else if(@tier = 11)
begin
	if(@tier10 is not null)
		return @agencyId
	else
		return @tier11
end
else if(@tier = 12)
begin
	if(@tier11 is not null)
		return @agencyId
	else
		return @tier12
end
else if(@tier = 13)
begin
	if(@tier12 is not null)
		return @agencyId
	else
		return @tier13
end
else if(@tier = 14)
begin
	if(@tier13 is not null)
		return @agencyId
	else
		return @tier14
end
else if(@tier = 15)
begin
	if(@tier14 is not null)
		return @agencyId
	else
		return @tier15
end
		
return null

end

GO
