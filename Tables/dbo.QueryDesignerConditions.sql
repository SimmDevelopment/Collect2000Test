CREATE TABLE [dbo].[QueryDesignerConditions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Path] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__QueryDesig__Path__2A0CEAEA] DEFAULT (''),
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data] [image] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueryDesignerConditions] ADD CONSTRAINT [PK__QueryDesignerCon__393A1FE1] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'QueryDesignerConditions', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'QueryDesignerConditions', 'COLUMN', N'Data'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'QueryDesignerConditions', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'QueryDesignerConditions', 'COLUMN', N'Path'
GO
