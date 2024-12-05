SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--7/1/2009 KMG Modified
--Query needed to be changed to concantenate the contact's name in the event Name was Null
--AIM_Contact.Name used to be the only available field and now we have parsed fields for the name
CREATE                 procedure [dbo].[AIM_SelectGroupByNameandType]
	@GroupTypeID int,
	@GroupName varchar(50)
AS

	select
		groupid
		,name
		,grouptypeid
		,[description]
		,Configuration
	from
		aim_group
	where
		name = @GroupName and grouptypeid = @GroupTypeID
	
	select 
		c.contactid
		,ISNULL(c.Name,ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' ' + ISNULL(LastName,''))
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
		g.name = @GroupName and g.grouptypeid = @GroupTypeID
	

GO
