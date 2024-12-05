SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[sp_insJobHistory] @JobNumber   varchar(50), @JobName     varchar(50), @ExecutedOn  Datetime, @ExecutedBy  varchar(50), @JobData     varchar(4000) As  Insert into JobHistory(JobNumber, JobName, ExecutedOn, ExecutedBy, JobData) Values (@JobNumber, @JobName, @ExecutedOn,  @ExecutedBy, @JobData)
GO
