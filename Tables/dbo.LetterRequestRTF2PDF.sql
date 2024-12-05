CREATE TABLE [dbo].[LetterRequestRTF2PDF]
(
[LetterRequestRTF2PDFId] [int] NOT NULL IDENTITY(1, 1),
[LetterRequestId] [int] NOT NULL,
[SizeBefore] [int] NULL,
[SizeAfter] [int] NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_LetterRequestRTF2PDF_CreatedWhen] DEFAULT (getdate()),
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LetterRequestRTF2PDF_CreatedBy] DEFAULT (suser_sname()),
[ConvertedWhen] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequestRTF2PDF] ADD CONSTRAINT [PK_LetterRequestRTF2PDF] PRIMARY KEY CLUSTERED ([LetterRequestRTF2PDFId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequestRTF2PDF] ADD CONSTRAINT [FK_LetterRequestRTF2PDF_LetterRequest] FOREIGN KEY ([LetterRequestId]) REFERENCES [dbo].[LetterRequest] ([LetterRequestID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains FK link to LetterRequest records where documentdata is/was originally rtf format. This tracks them so they can be identified as documentData that has been or if desired can be converted to pdf.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Datetime stamp when this record was converted.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'ConvertedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User/Application that was responsible for inserting this record.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this record was inserted.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the LetterRequest table.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'LetterRequestId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Identity value.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'LetterRequestRTF2PDFId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Size in bytes of converted DocumentData.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'SizeAfter'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Size in bytes of original DocumentData.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRTF2PDF', 'COLUMN', N'SizeBefore'
GO
