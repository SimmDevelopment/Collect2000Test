CREATE TABLE [dbo].[Attunely_Helper_PayMethodToValidValue]
(
[PayMethod] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValidMethod] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_PayMethodToValidValue] ADD CONSTRAINT [PK_Attunely_Helper_PayMethodToValidValue] PRIMARY KEY CLUSTERED ([PayMethod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Helper_PayMethodToValidValue] ADD CONSTRAINT [FK_Attunely_Helper_PayMethodToValidValue_Attunely_ValidFieldStringValues] FOREIGN KEY ([ValidMethod]) REFERENCES [dbo].[Attunely_ValidFieldStringValues] ([Id])
GO
