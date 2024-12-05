CREATE TABLE [dbo].[Receiver_Result]
(
[ResultId] [int] NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Result] ADD CONSTRAINT [PK_Receiver_Result] PRIMARY KEY CLUSTERED ([ResultId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_Result', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_Result', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_Result', 'COLUMN', N'ResultId'
GO
