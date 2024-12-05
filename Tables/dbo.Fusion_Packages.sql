CREATE TABLE [dbo].[Fusion_Packages]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceID] [int] NULL,
[Policy] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryID] [bigint] NULL,
[ManifestID] [uniqueidentifier] NULL CONSTRAINT [DF__Fusion_Pa__Manif__11C458C0] DEFAULT (newid()),
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProtectionID] [int] NULL,
[TransferID] [int] NULL,
[PickupAllPending] [bit] NULL CONSTRAINT [DF__Fusion_Pa__Picku__12B87CF9] DEFAULT (0),
[IncludeCoDebtors] [bit] NULL CONSTRAINT [DF__Fusion_Pa__Inclu__13ACA132] DEFAULT (0),
[AllowPreviouslyRequestedAccounts] [bit] NULL CONSTRAINT [DF__Fusion_Pa__Allow__14A0C56B] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fusion_Packages] ADD CONSTRAINT [PK_Fusion_Packages] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fusion_Packages] ADD CONSTRAINT [FK_Fusion_Packages_Protection] FOREIGN KEY ([ProtectionID]) REFERENCES [dbo].[Protection] ([ID])
GO
ALTER TABLE [dbo].[Fusion_Packages] ADD CONSTRAINT [FK_Fusion_Packages_SavedQueries] FOREIGN KEY ([QueryID]) REFERENCES [dbo].[SavedQueries] ([ID])
GO
ALTER TABLE [dbo].[Fusion_Packages] ADD CONSTRAINT [FK_Fusion_Packages_Services] FOREIGN KEY ([ServiceID]) REFERENCES [dbo].[Services] ([ServiceId])
GO
ALTER TABLE [dbo].[Fusion_Packages] ADD CONSTRAINT [FK_Fusion_Packages_Transfer] FOREIGN KEY ([TransferID]) REFERENCES [dbo].[Transfer] ([ID])
GO
