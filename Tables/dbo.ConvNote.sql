CREATE TABLE [dbo].[ConvNote]
(
[number] [int] NOT NULL,
[notetype] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[convnote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConvNote] ADD CONSTRAINT [PK_ConvNote] PRIMARY KEY CLUSTERED ([number], [notetype]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
