SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_InsertGroup    */


create  procedure [dbo].[AIM_InsertGroup]
	@groupTypeId int
AS

	insert into 
		AIM_Group
		(
			groupTypeId
		)
		values
		(
			@groupTypeId
		)
	select @@identity




GO
