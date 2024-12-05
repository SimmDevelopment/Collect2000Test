CREATE TABLE [bck].[Deceased_Remove_brianm_12052023_164212]
(
[historyid] [int] NOT NULL,
[ID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[DOD] [datetime] NULL,
[MatchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransmittedDate] [smalldatetime] NULL,
[ClaimDeadline] [datetime] NULL,
[DateFiled] [datetime] NULL,
[CaseNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorFax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorCity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDistrict] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDivision] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtZipcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
