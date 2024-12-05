CREATE TABLE [dbo].[Services_IdInfo]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[Ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Death_MatchCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BR_MatchCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RE_MatchCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CH_MatchCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DA_MatchCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_IdInfo] ADD CONSTRAINT [PK_Services_IdInfo] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
