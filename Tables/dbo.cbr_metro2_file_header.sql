CREATE TABLE [dbo].[cbr_metro2_file_header]
(
[cbr_metro2_file_headerId] [int] NOT NULL IDENTITY(1, 1),
[FileId] [int] NOT NULL,
[SetupId] [int] NOT NULL,
[CycleNumber] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InnovisProgramID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxProgramID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExperianProgramID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransUnionProgramID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramRevisionDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReporterName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReporterAddress] [varchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SoftwareVendorName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SoftwareVersionNumber] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReservedByte271] [varchar] (156) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordDescriptorWord] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_metro2_file_header] ADD CONSTRAINT [PK_cbr_metro2_file_header] PRIMARY KEY CLUSTERED ([cbr_metro2_file_headerId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique File Id', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_file_header', 'COLUMN', N'FileId'
GO
