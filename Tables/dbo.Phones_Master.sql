CREATE TABLE [dbo].[Phones_Master]
(
[MasterPhoneID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NOT NULL,
[PhoneTypeID] [int] NOT NULL,
[Relationship] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneStatusID] [int] NULL,
[OnHold] [bit] NOT NULL CONSTRAINT [DF__Phones_Ma__OnHol__22C592E7] DEFAULT ((0)),
[PhoneNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneExt] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorID] [int] NULL,
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF__Phones_Ma__DateA__23B9B720] DEFAULT (getdate()),
[RequestID] [int] NULL,
[PhoneName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NearbyContactID] [int] NULL,
[LastUpdated] [datetime] NULL CONSTRAINT [DF__Phones_Master__LastUpdated] DEFAULT (NULL),
[UpdatedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Phones_Master__UpdatedBy] DEFAULT (NULL)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Master] ADD CONSTRAINT [pk_Phones_Master] PRIMARY KEY NONCLUSTERED ([MasterPhoneID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PhonesMaster_DebtorID] ON [dbo].[Phones_Master] ([DebtorID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uk_Phones_Master] ON [dbo].[Phones_Master] ([DebtorID], [Number], [PhoneNumber], [PhoneTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PhonesMaster_Number] ON [dbo].[Phones_Master] ([Number], [PhoneTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PhonesMaster_PhoneNumber] ON [dbo].[Phones_Master] ([PhoneNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Phones_Master_masterphoneid_phonenumber_debtorid] ON [dbo].[Phones_Master] ([PhoneTypeID]) INCLUDE ([DebtorID], [MasterPhoneID], [PhoneNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Phones_Master_PhoneTypeID,PhoneStatusID] ON [dbo].[Phones_Master] ([PhoneTypeID], [PhoneStatusID]) INCLUDE ([DebtorID], [MasterPhoneID], [PhoneNumber]) ON [PRIMARY]
GO
