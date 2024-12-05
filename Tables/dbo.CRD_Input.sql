CREATE TABLE [dbo].[CRD_Input]
(
[number] [int] NULL,
[clinbr] [int] NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[descript] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uid] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CRD_Input] ADD CONSTRAINT [PK_CRD_Input] PRIMARY KEY CLUSTERED ([uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
