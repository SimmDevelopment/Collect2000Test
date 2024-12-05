CREATE TABLE [dbo].[Services_Accutrac_SkipOne]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[ACCTFROMCLT] [int] NULL,
[SOCSECNUMBER] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LASTNAMEFIRSTNAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOMEPHONE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESSLINE1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESSLINE2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIPCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POEPHONE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POENAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POEST] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NOTES1] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NOTES2] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NOTES3] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_Accutrac_SkipOne] ADD CONSTRAINT [PK_Services_Accutrac_SkipOne] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
