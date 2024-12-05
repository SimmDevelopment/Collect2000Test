CREATE TABLE [dbo].[WorkFlow_EventQueue]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__WorkFlow_EventQueue__ID] DEFAULT (newsequentialid()),
[EventID] [uniqueidentifier] NOT NULL,
[AccountID] [int] NOT NULL,
[Occurred] [datetime] NOT NULL CONSTRAINT [DF__WorkFlow_EventQueue__Occurred] DEFAULT (getdate()),
[EventVariable] [sql_variant] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_EventQueue] ADD CONSTRAINT [pk_WorkFlow_EventQueue] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_WorkFlow_EventQueue_AccountID] ON [dbo].[WorkFlow_EventQueue] ([AccountID]) WITH (FILLFACTOR=90, PAD_INDEX=ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_EventQueue] ADD CONSTRAINT [fk_WorkFlow_EventQueue_AccountID_master_number] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkFlow_EventQueue] ADD CONSTRAINT [fk_WorkFlow_EventQueue_EventID_WorkFlow_Events_ID] FOREIGN KEY ([EventID]) REFERENCES [dbo].[WorkFlow_Events] ([ID]) ON DELETE CASCADE
GO
