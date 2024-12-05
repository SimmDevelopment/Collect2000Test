CREATE TABLE [dbo].[csusers]
(
[userid] [int] NOT NULL IDENTITY(0, 1),
[username] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[password] [int] NOT NULL,
[email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[supervisoremail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[notifyemail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_csusers_notifyemail] DEFAULT (''),
[firstname] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lastname] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[superuser] [smallint] NOT NULL CONSTRAINT [DF__csusers__superus__20B7BF83] DEFAULT (0),
[disabled] [smallint] NOT NULL CONSTRAINT [DF__csusers__disable__21ABE3BC] DEFAULT (0),
[audituser] [smallint] NOT NULL CONSTRAINT [DF__csusers__auditus__22A007F5] DEFAULT (0),
[ViewNotes] [bit] NOT NULL,
[ViewHistory] [bit] NOT NULL,
[ViewPDC] [bit] NOT NULL,
[ViewPODs] [bit] NOT NULL,
[PerformClose] [bit] NOT NULL,
[PerformAdjustment] [bit] NOT NULL,
[PerformDemographics] [bit] NOT NULL,
[PerformReports] [bit] NOT NULL,
[PerformSearch] [bit] NOT NULL,
[PerformNotes] [bit] NOT NULL,
[ViewDemographics] [bit] NOT NULL CONSTRAINT [ViewDemographicsConstranit] DEFAULT (1),
[QuickAddTemplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[View Notes] [bit] NOT NULL CONSTRAINT [DF__csusers__View No__23942C2E] DEFAULT ((0)),
[View History] [bit] NOT NULL CONSTRAINT [DF__csusers__View Hi__24885067] DEFAULT ((0)),
[View PDC] [bit] NOT NULL CONSTRAINT [DF__csusers__View PD__257C74A0] DEFAULT ((0)),
[View PODs] [bit] NOT NULL CONSTRAINT [DF__csusers__View PO__267098D9] DEFAULT ((0)),
[Perform Close] [bit] NOT NULL CONSTRAINT [DF__csusers__Perform__2764BD12] DEFAULT ((0)),
[Perform Adjustment] [bit] NOT NULL CONSTRAINT [DF__csusers__Perform__2858E14B] DEFAULT ((0)),
[Perform Demographics] [bit] NOT NULL CONSTRAINT [DF__csusers__Perform__294D0584] DEFAULT ((0)),
[Perform Reports] [bit] NOT NULL CONSTRAINT [DF__csusers__Perform__2A4129BD] DEFAULT ((0)),
[Perform Search] [bit] NOT NULL CONSTRAINT [DF__csusers__Perform__2B354DF6] DEFAULT ((0)),
[Perform Notes] [bit] NOT NULL CONSTRAINT [DF__csusers__Perform__2C29722F] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csusers] ADD CONSTRAINT [PK_csusers] PRIMARY KEY CLUSTERED ([userid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude.CS', 'SCHEMA', N'dbo', 'TABLE', N'csusers', NULL, NULL
GO
