CREATE TABLE [dbo].[States]
(
[Code] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OpenStatute] [tinyint] NULL,
[WrittenStatute] [tinyint] NULL,
[ApplicableStatute] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[States] ADD CONSTRAINT [PK_states] PRIMARY KEY CLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'States', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'States', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'States', 'COLUMN', N'Description'
GO
