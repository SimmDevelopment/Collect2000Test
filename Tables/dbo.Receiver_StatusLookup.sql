CREATE TABLE [dbo].[Receiver_StatusLookup]
(
[StatusLookupId] [int] NOT NULL IDENTITY(1, 1),
[AgencyStatus] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientStatus] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [int] NULL,
[HoldDays] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_StatusLookup] ADD CONSTRAINT [PK_Receiver_StatusLookup] PRIMARY KEY CLUSTERED ([StatusLookupId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
