CREATE TABLE [dbo].[tmpMyQueue2]
(
[Number] [int] NULL,
[DONE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastAccessed] [datetime] NOT NULL,
[SetFollowup] [bit] NULL
) ON [PRIMARY]
GO
