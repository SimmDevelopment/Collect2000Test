CREATE TABLE [dbo].[Services_FirstData_FastBatch_Deceased]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[MatchedSSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchedSurname] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchedFirstName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfDeathMMDDCCYY] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirthMMDDCCYY] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addressifavailable] [varchar] (39) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cityifavailable] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Stateifavailable] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCodeifavailable] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_Deceased] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_Deceased] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
