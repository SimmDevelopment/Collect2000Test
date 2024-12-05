CREATE TABLE [dbo].[Custom_CustomerReference]
(
[CustomerReferenceId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CCustomerId] [int] NULL,
[Configuration] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientReferenceId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hidden] [bit] NULL CONSTRAINT [DF_Custom_CustomerReference_Hidden] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_CustomerReference] ADD CONSTRAINT [PK_Custom_CustomerReference] PRIMARY KEY CLUSTERED ([CustomerReferenceId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_CustomerReference] ADD CONSTRAINT [IX_Custom_CustomerReference] UNIQUE NONCLUSTERED ([TreePath]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
