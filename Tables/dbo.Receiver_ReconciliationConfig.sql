CREATE TABLE [dbo].[Receiver_ReconciliationConfig]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClientID] [int] NOT NULL,
[Bucket1] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket1] DEFAULT ((1)),
[Bucket2] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket2] DEFAULT ((1)),
[Bucket3] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket3] DEFAULT ((1)),
[Bucket4] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket4] DEFAULT ((1)),
[Bucket5] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket5] DEFAULT ((1)),
[Bucket6] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket6] DEFAULT ((1)),
[Bucket7] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket7] DEFAULT ((1)),
[Bucket8] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket8] DEFAULT ((1)),
[Bucket9] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket9] DEFAULT ((1)),
[Bucket10] [bit] NOT NULL CONSTRAINT [DF_Receiver_ReconciliationConfig_Bucket10] DEFAULT ((1))
) ON [PRIMARY]
GO
