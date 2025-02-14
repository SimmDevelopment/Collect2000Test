CREATE TABLE [dbo].[Phones_Preferences]
(
[PhonesPreferencesID] [int] NOT NULL IDENTITY(1, 1),
[MasterPhoneId] [int] NOT NULL,
[SundayDoNotCall] [bit] NULL,
[SundayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SundayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SundayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SundayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MondayDoNotCall] [bit] NULL,
[MondayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MondayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MondayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MondayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TuesdayDoNotCall] [bit] NULL,
[TuesdayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TuesdayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TuesdayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TuesdayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WednesdayDoNotCall] [bit] NULL,
[WednesdayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WednesdayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WednesdayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WednesdayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThursdayDoNotCall] [bit] NULL,
[ThursdayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThursdayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThursdayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThursdayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FridayDoNotCall] [bit] NULL,
[FridayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FridayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FridayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FridayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaturdayDoNotCall] [bit] NULL,
[SaturdayCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaturdayCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaturdayNoCallWindowStart] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaturdayNoCallWindowEnd] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Preferences] ADD CONSTRAINT [pk_Phones_Preferences] PRIMARY KEY NONCLUSTERED ([PhonesPreferencesID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Phones_Preferences_MasterPhoneId] ON [dbo].[Phones_Preferences] ([MasterPhoneId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Preferences] ADD CONSTRAINT [fk_Phones_Preferences_Phones_Master] FOREIGN KEY ([MasterPhoneId]) REFERENCES [dbo].[Phones_Master] ([MasterPhoneID])
GO
