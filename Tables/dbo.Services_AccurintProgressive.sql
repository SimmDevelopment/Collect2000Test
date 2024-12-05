CREATE TABLE [dbo].[Services_AccurintProgressive]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[name-last] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name-first] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name-middle] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address-1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneno] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_first_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_middle_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_last_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_suffix_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone10_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_name-dial_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type_1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_date_first_1] [datetime] NULL,
[subj_date_last_1] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_AccurintProgressive] ADD CONSTRAINT [PK_Services_AccurintProgressive] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
