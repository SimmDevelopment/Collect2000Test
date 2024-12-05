SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[sp_updDeskMoverJobs] @Data char(4000), @IsBatch char(1), @Name varchar(200) as Update DeskMoverJobs Set Data = @Data, IsBatch = @IsBatch Where Name = @Name
GO
