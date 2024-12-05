CREATE TABLE [dbo].[Services_TransUnion_CPE2_PN01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneQualifier] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AvalabilityIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AreaCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TelephoneNumber] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_PN01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_PN01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
