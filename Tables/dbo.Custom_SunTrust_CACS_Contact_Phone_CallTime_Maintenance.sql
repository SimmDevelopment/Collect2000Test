CREATE TABLE [dbo].[Custom_SunTrust_CACS_Contact_Phone_CallTime_Maintenance]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalKey] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimePref] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Monday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tuesday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wednesday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Thursday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Friday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Saturday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sunday] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnyTime] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndTime] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeZone] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SunTrust_CACS_Contact_Phone_CallTime_Maintenance] ADD CONSTRAINT [PK_Custom_SunTrust_CACS_Contact_Phone_CallTime_Maintenance] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
