CREATE TABLE [dbo].[Attunely_ValidFieldStringValues]
(
[Id] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Discriminator] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_ValidFieldStringValues] ADD CONSTRAINT [PK_Attunely_ValidFieldStringValues] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
