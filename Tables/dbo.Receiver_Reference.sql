CREATE TABLE [dbo].[Receiver_Reference]
(
[ReferenceId] [int] NOT NULL IDENTITY(1, 1),
[SenderNumber] [int] NULL,
[ReceiverNumber] [int] NULL,
[ClientId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Reference] ADD CONSTRAINT [PK_Receiver_Reference] PRIMARY KEY CLUSTERED ([ReferenceId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Reference] ADD CONSTRAINT [IX_Receiver_Reference] UNIQUE NONCLUSTERED ([SenderNumber], [ReceiverNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Reference] ADD CONSTRAINT [FK_Receiver_Reference_Receiver_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Receiver_Client] ([ClientId])
GO
