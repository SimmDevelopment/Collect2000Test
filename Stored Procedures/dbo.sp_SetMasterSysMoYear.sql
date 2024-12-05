SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*Create Procedure sp_SetMasterSysMoYear   */
CREATE PROCEDURE [dbo].[sp_SetMasterSysMoYear]
AS
update master set sysMonth = month(received), sysYear = Year(received) where SysMonth is null
GO
