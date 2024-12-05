CREATE TABLE [dbo].[Pagers]
(
[number] [int] NULL,
[pager] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Pagers] ON [dbo].[Pagers] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
