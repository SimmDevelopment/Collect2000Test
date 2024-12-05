CREATE TABLE [dbo].[ComplianceItems]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OrdinalPosition] [tinyint] NOT NULL,
[Item] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComplianceItems] ADD CONSTRAINT [PK_ComplianceItems] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_ComplianceItems_OrdinalPosition] ON [dbo].[ComplianceItems] ([OrdinalPosition]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
