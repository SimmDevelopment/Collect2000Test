CREATE TABLE [dbo].[ShermanBALFileControl]
(
[NextNumber] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ShermanBALFileControl_NextNumber] ON [dbo].[ShermanBALFileControl] ([NextNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
