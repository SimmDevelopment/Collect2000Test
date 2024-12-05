SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[AIM_UpdateReport]
@reportid int,
@name varchar(50) ,
@description varchar(250),
@configuration text 

AS

UPDATE AIM_Report
SET 
Name = @name,
Description = @description,
Configuration = @configuration
WHERE reportid = @reportid




GO
