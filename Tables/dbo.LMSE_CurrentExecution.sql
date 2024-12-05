CREATE TABLE [dbo].[LMSE_CurrentExecution]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [uniqueidentifier] NULL,
[Key] [sql_variant] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LMSE_CurrentExecution] ADD CONSTRAINT [PK__LMSE_Cur__3214EC27BA83587C] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
