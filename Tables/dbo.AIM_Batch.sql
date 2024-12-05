CREATE TABLE [dbo].[AIM_Batch]
(
[BatchId] [int] NOT NULL IDENTITY(1, 1),
[StartedDateTime] [datetime] NULL,
[CompletedDateTime] [datetime] NULL,
[SystemMonth] [int] NULL,
[SystemYear] [int] NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Batch] ADD CONSTRAINT [PK_Batch] PRIMARY KEY CLUSTERED ([BatchId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_Batch_SystemYearSystemMonth] ON [dbo].[AIM_Batch] ([SystemYear], [SystemMonth]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Batch', 'COLUMN', N'BatchId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date batch completed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Batch', 'COLUMN', N'CompletedDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date batch created', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Batch', 'COLUMN', N'StartedDateTime'
GO
