CREATE TABLE [dbo].[HCS_Daily_Activity]
(
[CreditorID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityType] [int] NOT NULL,
[Amount] [money] NOT NULL CONSTRAINT [DF__HCS_Daily__Amoun__2276B61A] DEFAULT (0),
[TotalItems] [int] NOT NULL CONSTRAINT [DF__HCS_Daily__Total__236ADA53] DEFAULT (0),
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCS_Daily_Activity] ADD CONSTRAINT [PK_HCS_Daily_Activity] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreditorIDInd] ON [dbo].[HCS_Daily_Activity] ([CreditorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
