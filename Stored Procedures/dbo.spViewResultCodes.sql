SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spViewResultCodes    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE procedure [dbo].[spViewResultCodes]
as 
  select code,code+' - '+dbo.ProperCase(Description) as Description,note from result
  order by code
GO
