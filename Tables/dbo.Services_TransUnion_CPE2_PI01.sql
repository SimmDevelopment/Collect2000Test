CREATE TABLE [dbo].[Services_TransUnion_CPE2_PI01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SocialSecurityNumber] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirth] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_PI01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_PI01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
