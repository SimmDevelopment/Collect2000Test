SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_GetCompanyName     */

create  procedure [dbo].[AIM_GetCompanyName]

AS

	select
		top 1
		company as companyname
	from	
		AIM_controlfileview


GO
