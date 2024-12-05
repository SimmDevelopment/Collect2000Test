SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  Stored Procedure dbo.spPurgeActivityLog    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE proc [dbo].[spPurgeActivityLog]
as 
  DECLARE @desc varchar(8000)
  delete from csactivitylog  where datediff(day,created,getdate()) > 30
  SET @desc = 'Purged activity log ('+cast(@@ROWCOUNT as varchar)+' old rows deleted)'
  EXEC spAddActivity 'system',0,@desc
GO
