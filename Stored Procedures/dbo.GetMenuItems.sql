SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROC [dbo].[GetMenuItems] @username varchar(15)
AS
select m.* from usermenus um
  inner join menus m on m.menuguid = um.menuguid
  where um.userid=(select userid from csusers where username=@username)
  order by m.menu

GO
