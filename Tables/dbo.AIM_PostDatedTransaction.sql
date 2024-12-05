CREATE TABLE [dbo].[AIM_PostDatedTransaction]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BatchFileHistoryID] [int] NOT NULL,
[AccountID] [int] NULL,
[Active] [bit] NULL CONSTRAINT [DF__AIM_PostD__Activ__5FCEA127] DEFAULT ((1)),
[AgencyID] [int] NULL,
[Created] [datetime] NULL CONSTRAINT [DF__AIM_PostD__Creat__60C2C560] DEFAULT (getdate()),
[DueDate] [datetime] NULL,
[Amount] [money] NULL
) ON [PRIMARY]
GO
