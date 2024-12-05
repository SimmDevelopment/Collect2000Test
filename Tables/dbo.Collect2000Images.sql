CREATE TABLE [dbo].[Collect2000Images]
(
[Number] [int] NULL,
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheImage] [image] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to retain encrypted images of creditcard information', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Images', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descritpion of item encrypted', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Images', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Images', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encrypted image data', 'SCHEMA', N'dbo', 'TABLE', N'Collect2000Images', 'COLUMN', N'TheImage'
GO
