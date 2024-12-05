CREATE TABLE [dbo].[DistributionTemplate]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conditions] [image] NULL,
[Config] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionTemplate] ADD CONSTRAINT [PK_DistributionTemplates] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionTemplate] ADD CONSTRAINT [UNQ_DistributionTemplateName] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
