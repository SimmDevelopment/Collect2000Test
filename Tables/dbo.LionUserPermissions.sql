CREATE TABLE [dbo].[LionUserPermissions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LionUserId] [int] NULL,
[CanViewDebtor] [bit] NULL CONSTRAINT [DF_LionUserPermissions_CanViewDebtor] DEFAULT (0),
[CanViewNotes] [bit] NULL CONSTRAINT [DF_LionUserPermissions_CanViewNotes] DEFAULT (0),
[CanViewDemographics] [bit] NULL,
[CanViewPOD] [bit] NULL CONSTRAINT [DF_LionUserPermissions_CanViewPOD] DEFAULT (0),
[CanInsertNote] [bit] NULL,
[CanSearchByName] [bit] NULL CONSTRAINT [DF_LionUserPermissions_SearchByName] DEFAULT (0),
[CanSearchByDebtorId] [bit] NULL CONSTRAINT [DF_LionUserPermissions_SearchByDebtorId] DEFAULT (0),
[CanSearchByAccount] [bit] NULL CONSTRAINT [DF_LionUserPermissions_SearchByAccount] DEFAULT (0),
[CanSearchBySsn] [bit] NULL CONSTRAINT [DF_LionUserPermissions_SearchBySsn] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionUserPermissions] ADD CONSTRAINT [PK_LionUserPermissions] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionUserPermissions] ADD CONSTRAINT [FK_LionUserPermissions_LionUsers] FOREIGN KEY ([LionUserId]) REFERENCES [dbo].[LionUsers] ([ID]) ON DELETE CASCADE
GO
