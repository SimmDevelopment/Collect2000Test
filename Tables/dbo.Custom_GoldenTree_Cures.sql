CREATE TABLE [dbo].[Custom_GoldenTree_Cures]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BAN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [datetime] NULL,
[StatusCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaysDelq] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_GoldenTree_Cures] ADD CONSTRAINT [PK_Custom_GoldenTree_Cures] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
