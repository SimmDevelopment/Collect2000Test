SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_ControlFile_Get*/
CREATE Procedure [dbo].[sp_ControlFile_Get]
	/* Param List */
AS

select * from controlfile

GO
