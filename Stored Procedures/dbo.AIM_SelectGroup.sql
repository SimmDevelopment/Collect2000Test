SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE                 procedure [dbo].[AIM_SelectGroup]
	@groupId int
AS

	select
		groupid
		,name
		,grouptypeid
		,[description]
		,Configuration
		,Street1,Street2,City,State,Zipcode,Phone,Fax,TreePath
	from
		aim_group
	where
		groupid = @groupid
	
	select 
		c.contactid
		,c.Name
		,c.Role
		,assn.OwnershipPercentage
		,c.Phone
		,Email
		,Address
		,c.City
		,c.State
		,Zip
		,contacttypeid
		,assn.groupcontactassnid
		,g.groupid		
	from
		aim_contact c
		join aim_groupcontactassn assn on assn.contactid = c.contactid
		join aim_group g on g.groupid = assn.groupid
	where
		g.groupid = @groupid


	declare @groupTypeId int
	select
		@groupTypeId = grouptypeid
	from
		aim_group
	where
		groupid = @groupid

	if(@groupTypeid = 0) -- buyers
	begin
		select
			PortfolioId
			,Code
			,ContractDate
			,Amount		
		from
			aim_portfolio
		where
			buyergroupid = @groupId
			and portfoliotypeid = 1
	end
	else if (@groupTypeId = 1) -- sellers
	begin
		select
			PortfolioId
			,Code
			,ContractDate
			,Amount		
		from
			aim_portfolio
		where
			sellergroupid = @groupId
			and portfoliotypeid = 0
	end
	else if (@groupTypeId = 2) -- investors
	begin
		select
			PortfolioId
			,Code
			,ContractDate
			,Amount		
		from
			aim_portfolio
		where
			investorgroupid = @groupId
	end






GO
