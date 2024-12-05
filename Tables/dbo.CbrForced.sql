CREATE TABLE [dbo].[CbrForced]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NULL,
[CreatedDate] [datetime] NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CbrForced] ADD CONSTRAINT [PK_CbrForced] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
