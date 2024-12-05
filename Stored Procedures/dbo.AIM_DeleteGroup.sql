SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_DeleteGroup    */
CREATE   procedure [dbo].[AIM_DeleteGroup]
	@groupId int
AS

		declare @groupTypeId int
	select
		@groupTypeId = grouptypeid
	from
		AIM_Group
	where
		groupid = @groupid

	begin tran
	delete
		aim_groupcontactassn
	where
		groupid = @groupid

	if(@groupTypeId <> 2)
	begin
		delete 
			aim_contact
		from 
			aim_contact c
			join aim_groupcontactassn assn on c.contactid = assn.contactid
			join aim_group g on assn.groupid = g.groupid
		where
			g.groupid = @groupid
	end

	delete
		aim_contact
	from
		aim_contact c
		left outer join aim_groupcontactassn assn on c.contactid = assn.contactid
	where
		c.contacttypeid = 2
		and assn.groupcontactassnid is null

	delete
		aim_group
	where
		groupid = @groupid
	

	IF (@@ERROR <> 0)
    		rollback tran

	commit tran




GO
