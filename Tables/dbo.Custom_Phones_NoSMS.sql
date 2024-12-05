CREATE TABLE [dbo].[Custom_Phones_NoSMS]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[phone_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[reason] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Phones_NoSMS] ADD CONSTRAINT [PK__Custom_P__3213E83F124D8494] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
