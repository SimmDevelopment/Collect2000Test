CREATE TABLE [dbo].[Receiver_ASTSConfig]
(
[ASTSConfigId] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NOT NULL,
[Action] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Result] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notification] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomGroupID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_ASTSConfig] ADD CONSTRAINT [PK_Receiver_ASTSConfig] PRIMARY KEY CLUSTERED ([ASTSConfigId]) ON [PRIMARY]
GO
