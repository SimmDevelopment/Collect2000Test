CREATE TABLE [dbo].[NewbizDupes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Received] [datetime] NULL,
[Original] [money] NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewbizDupes] ADD CONSTRAINT [PK_NewbizDupes] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_newbizdupes] ON [dbo].[NewbizDupes] ([Customer], [Received]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
