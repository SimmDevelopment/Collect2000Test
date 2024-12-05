CREATE TABLE [dbo].[Custom_Applied_Potential]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Type] [int] NOT NULL,
[FileName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF_Custom_Applied_Potential_Date] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Applied_Potential] ADD CONSTRAINT [PK_Custom_Applied_Potential] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
