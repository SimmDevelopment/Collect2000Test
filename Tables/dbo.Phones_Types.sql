CREATE TABLE [dbo].[Phones_Types]
(
[PhoneTypeID] [int] NOT NULL IDENTITY(1, 1),
[PhoneTypeDescription] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneTypeMapping] [tinyint] NULL,
[Disabled] [bit] NOT NULL CONSTRAINT [DF__Phones_Ty__Disab__287E6C3D] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Types] ADD CONSTRAINT [PK_Phones_Types] PRIMARY KEY CLUSTERED ([PhoneTypeID]) ON [PRIMARY]
GO
