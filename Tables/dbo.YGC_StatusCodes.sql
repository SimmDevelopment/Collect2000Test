CREATE TABLE [dbo].[YGC_StatusCodes]
(
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusType] [bit] NOT NULL CONSTRAINT [DF__YGC_Statu__Accou__2279E376] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[YGC_StatusCodes] ADD CONSTRAINT [PK_YGC_StatusCodes] PRIMARY KEY CLUSTERED ([Status], [PCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
