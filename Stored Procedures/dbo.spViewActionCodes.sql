SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/****** Object:  Stored Procedure dbo.spViewActionCodes    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE procedure [dbo].[spViewActionCodes]
as 
  select code,code+' - '+dbo.ProperCase(Description) as Description from action
  order by code
GO
