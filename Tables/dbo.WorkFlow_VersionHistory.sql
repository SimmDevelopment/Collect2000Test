CREATE TABLE [dbo].[WorkFlow_VersionHistory]
(
[ID] [uniqueidentifier] NOT NULL,
[Version] [int] NOT NULL,
[ModifiedBy] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
[Name] [nvarchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartingActivity] [uniqueidentifier] NULL,
[LayoutXML] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_VersionHistory] ADD CONSTRAINT [pk_WorkFlow_VersionHistory] PRIMARY KEY NONCLUSTERED ([ID], [Version]) ON [PRIMARY]
GO
