CREATE TABLE [dbo].[AIM_WorkEfforts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[AgencyID] [int] NOT NULL,
[ActionDateTime] [datetime] NOT NULL,
[Category] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_WorkEfforts] ADD CONSTRAINT [PK_AIM_WorkEfforts] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table contains work effort information for an account from the forwarded', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date time the work effort occurred', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'ActionDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign Key to AIM_Agency table to identify the Agency', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'AgencyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The category of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'Category'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The code for the work effort', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description for the work effort', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_WorkEfforts', 'COLUMN', N'ID'
GO
