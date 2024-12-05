CREATE TABLE [dbo].[tmpMyQueue]
(
[Number] [int] NOT NULL,
[DONE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastAccessed] [datetime] NOT NULL,
[SetFollowup] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmpMyQueue_LastAccessed] ON [dbo].[tmpMyQueue] ([LastAccessed]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
