SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_SelectContactInfoFromName    */





CREATE          procedure [dbo].[AIM_SelectContactInfoFromName]
	@name varchar(50)
AS

select 
	contactid
	,Name
	,Phone
	,Email
	,address
	,city
	,state
	,zip
	,contacttypeid
	,role
from
	aim_contact c
where
	name = @name

GO
