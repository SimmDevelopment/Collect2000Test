CREATE TABLE [dbo].[Phones_Statuses]
(
[PhoneStatusID] [int] NOT NULL IDENTITY(1, 1),
[PhoneStatusDescription] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NULL,
[CanChange] [bit] NOT NULL CONSTRAINT [DF__Phones_St__CanCh__2B5AD8E8] DEFAULT ((1)),
[Disabled] [bit] NOT NULL CONSTRAINT [DF__Phones_St__Disab__2C4EFD21] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Statuses] ADD CONSTRAINT [pk_Phones_Statuses] PRIMARY KEY CLUSTERED ([PhoneStatusID]) ON [PRIMARY]
GO
