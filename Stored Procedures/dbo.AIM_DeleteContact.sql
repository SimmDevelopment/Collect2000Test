SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_DeleteContact    */

CREATE      procedure [dbo].[AIM_DeleteContact]
	@contactId int
	,@contactTypeId int
	,@groupId int
AS

	declare @groupTypeId int
	select
		@groupTypeId = grouptypeid
	from
		AIM_Group
	where
		groupid = @groupid

	delete
		aim_groupcontactassn
	where
		contactid = @contactId
		and groupid = @groupId

	if(@groupTypeId <> 2)
	begin
		delete 
			aim_contact
		where
			contactid = @contactId
	end

	delete
		aim_contact
	from
		aim_contact c
		left outer join aim_groupcontactassn assn on c.contactid = assn.contactid
	where
		c.contacttypeid = 2
		and assn.groupcontactassnid is null


GO
