CREATE TABLE [dbo].[WorkFlows]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlows__ID] DEFAULT (newsequentialid()),
[Name] [nvarchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartingActivity] [uniqueidentifier] NULL,
[LayoutXML] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastEvaluated] [datetime] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__WorkFlows__Active] DEFAULT ((1)),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ModifiedBy] [int] NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
[Version] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlows] ADD CONSTRAINT [pk_WorkFlows] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_WorkFlows_Name] ON [dbo].[WorkFlows] ([Name]) ON [PRIMARY]
GO
