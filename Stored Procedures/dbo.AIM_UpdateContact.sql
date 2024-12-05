SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_UpdateContact    */






CREATE      procedure [dbo].[AIM_UpdateContact]
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


	update 
		aim_contact
	set
		name = @name
		,phone = @phone
		,email = @email
		,address = @address
		,city = @city
		,state = @state
		,zip = @zip
		,contacttypeid = @contacttypeid	
		,role = @role
	where
		contactid = @contactid	

	update
		aim_groupcontactassn
	set
		ownershippercentage  = @ownershippercentage
	where
		groupcontactassnid = @groupcontactassnid








GO
