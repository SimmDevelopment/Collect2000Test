CREATE TABLE [dbo].[LionUsers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ReportRoleID] [int] NULL,
[CustomerGroupID] [int] NOT NULL,
[SupervisiorEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NotifyEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NULL,
[LionPassword] [image] NULL,
[CanViewDebtor] [bit] NULL CONSTRAINT [DF_LionUsers_CanViewDebtor] DEFAULT (0),
[CanViewNotes] [bit] NULL CONSTRAINT [DF_LionUsers_CanViewNotes] DEFAULT (0),
[CanViewDemographics] [bit] NULL CONSTRAINT [DF_LionUsers_CanViewDemographics] DEFAULT (0),
[CanViewPOD] [bit] NULL CONSTRAINT [DF_LionUsers_CanViewPOD] DEFAULT (0),
[CanModifyDebtor] [bit] NULL CONSTRAINT [DF_LionUsers_CanModifyDebtor] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionUsers] ADD CONSTRAINT [PK_LionUsers] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionUsers] ADD CONSTRAINT [FK_LionUsers_LionReportRoles] FOREIGN KEY ([ReportRoleID]) REFERENCES [dbo].[LionReportRoles] ([ID])
GO
ALTER TABLE [dbo].[LionUsers] ADD CONSTRAINT [FK_LionUsers_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
