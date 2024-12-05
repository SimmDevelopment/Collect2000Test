CREATE TABLE [dbo].[AIM_TempSampleAccounts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_TempSampleAccounts] ADD CONSTRAINT [PK_AIM_TempSampleAccounts] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
