SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create              procedure [dbo].[AIM_GetPortfoliosIfExists]

as
begin

if exists (select * from dbo.sysobjects where id = object_id(N'[aim_portfolio]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	SELECT portfolioid,code,portfoliotypeid FROM aim_portfolio

end

GO
