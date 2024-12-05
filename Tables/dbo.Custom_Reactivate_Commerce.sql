CREATE TABLE [dbo].[Custom_Reactivate_Commerce]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current1] [money] NULL,
[current2] [money] NULL,
[current3] [money] NULL,
[current4] [money] NULL,
[current5] [money] NULL,
[current6] [money] NULL,
[current7] [money] NULL,
[current8] [money] NULL,
[current9] [money] NULL,
[current10] [money] NULL,
[received] [datetime] NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Reactivate_Commerce] ADD CONSTRAINT [PK_Custom_Reactivate_Commerce] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
