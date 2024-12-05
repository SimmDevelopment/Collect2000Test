SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[sp_Master2_GetByName]
	@Name varchar(50)
AS
select * from Master2 where [name] like @Name + '%' order by name

/******************************************************************************
**		File: 
**		Name: sp_Master2_GetByName
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/




GO
GRANT EXECUTE ON  [dbo].[sp_Master2_GetByName] TO [public]
GO
