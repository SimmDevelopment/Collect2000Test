CREATE TABLE [dbo].[Phones_Attempts]
(
[CallAttemptID] [int] NOT NULL IDENTITY(1, 1),
[MasterPhoneID] [int] NOT NULL,
[AttemptedDate] [datetime] NOT NULL CONSTRAINT [DF__Phones_At__Attem__3207D677] DEFAULT (getdate()),
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__Phones_At__Activ__32FBFAB0] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones_Attempts] ADD CONSTRAINT [pk_Phones_Attempts] PRIMARY KEY NONCLUSTERED ([CallAttemptID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Phones_Attempts_MasterPhoneID] ON [dbo].[Phones_Attempts] ([MasterPhoneID]) ON [PRIMARY]
GO
