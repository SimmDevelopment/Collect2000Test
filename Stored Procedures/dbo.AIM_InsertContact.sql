SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  Stored Procedure dbo.AIM_InsertContact    */





CREATE     procedure [dbo].[AIM_InsertContact]
	@contactId int
	,@name varchar(50)
	,@phone varchar(50)
	,@email varchar(50)
	,@address varchar(50)
	,@city varchar(50)
	,@state varchar(50)
	,@zip varchar(50)
	,@contacttypeid int
	,@groupcontactassnid int
	,@groupid int
	,@ownershippercentage float
	,@role varchar(200)
AS

	if(@contactid is null)
	begin
		insert into aim_contact
		(
			name
			,phone
			,email
			,address
			,city
			,state
			,zip
			,contacttypeid	
			,role
		)
		values
		(
			@name
			,@phone
			,@email
			,@address
			,@city
			,@state
			,@zip
			,@contacttypeid
			,@role
		)

		select @contactid = @@identity
	end

	insert into aim_groupcontactassn
	(
		groupid
		,contactid
		,ownershippercentage
	)
	values
	(
		@groupid
		,@contactid
		,@ownershippercentage
	)











GO
