CREATE TABLE [dbo].[Services_TLO_Deceased]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[TLOFirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOMiddleName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOLastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOSuffix] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOStreet1] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOStreet2] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOCity] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOZip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirth] [datetime] NULL,
[DateOfDeath] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TLO_Deceased] ADD CONSTRAINT [PK_Services_TLO_Deceased] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
