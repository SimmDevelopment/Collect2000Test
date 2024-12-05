CREATE TABLE [dbo].[DistributionGroup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionGroup] ADD CONSTRAINT [PK_DistributionGroup] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionGroup] ADD CONSTRAINT [UNQ_DistributionGroupName] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
