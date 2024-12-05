CREATE TABLE [dbo].[Attunely_Modifiers]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifierKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Modifiers] ADD CONSTRAINT [PK_Attunely_Modifiers] PRIMARY KEY CLUSTERED ([AccountKey], [ModifierKey]) ON [PRIMARY]
GO
