CREATE TABLE [dbo].[MidlandsRecallAckSent]
(
[number] [int] NULL,
[datesent] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_MidlandsRecallAckSent_datesent] ON [dbo].[MidlandsRecallAckSent] ([datesent]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_MidlandsRecallAckSent_number] ON [dbo].[MidlandsRecallAckSent] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
