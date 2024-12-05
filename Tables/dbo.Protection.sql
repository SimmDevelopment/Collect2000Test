CREATE TABLE [dbo].[Protection]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocalPublicKey] [image] NULL,
[LocalPrivateKey] [image] NULL,
[LocalPassphrase] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThirdPartyPublicKey] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Protection] ADD CONSTRAINT [PK_PGPEncryption] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
