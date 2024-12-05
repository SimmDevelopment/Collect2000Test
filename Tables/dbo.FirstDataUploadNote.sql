CREATE TABLE [dbo].[FirstDataUploadNote]
(
[Number] [int] NOT NULL,
[TransmittedDate] [datetime] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstDataUploadNote] ADD CONSTRAINT [PK_FirstDataUploadNote] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndNumber] ON [dbo].[FirstDataUploadNote] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
