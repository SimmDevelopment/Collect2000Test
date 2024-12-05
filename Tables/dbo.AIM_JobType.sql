CREATE TABLE [dbo].[AIM_JobType]
(
[jobtypeid] [int] NOT NULL IDENTITY(1, 1),
[description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_JobType] ADD CONSTRAINT [pk_jobtype] PRIMARY KEY CLUSTERED ([jobtypeid]) ON [PRIMARY]
GO
