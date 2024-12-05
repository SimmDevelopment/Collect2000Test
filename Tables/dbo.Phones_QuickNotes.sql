CREATE TABLE [dbo].[Phones_QuickNotes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResultCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneStatusID] [int] NULL,
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__Phones_Qu__Activ__12E430D9] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_QuickNotes] ADD CONSTRAINT [pk_Phones_QuickNotes] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_QuickNotes] ADD CONSTRAINT [uq_Phones_QuickNotes_Name] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
