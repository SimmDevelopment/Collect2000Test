CREATE TABLE [dbo].[VirtualQueue]
(
[VirtualQueueID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NOT NULL,
[SessionID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VirtualQueue] ADD CONSTRAINT [PK_VirtualQueue] PRIMARY KEY CLUSTERED ([VirtualQueueID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
