CREATE TABLE [dbo].[Services_SIMM_Internal_Deceased]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[firstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dob] [datetime] NULL,
[DOD] [datetime] NULL,
[ClaimDeadline] [datetime] NULL,
[DateFiled] [datetime] NULL,
[CaseNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorFax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutorZipcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDistrict] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDivision] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtZipcode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SIMM_Internal_Deceased] ADD CONSTRAINT [PK_Services_SIMM_Internal_Deceased] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
