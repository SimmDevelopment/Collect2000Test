CREATE TABLE [dbo].[Services_TransUnion_CPE2_NM01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnparsedName] [varchar] (61) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName1] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName2] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_NM01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_NM01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
