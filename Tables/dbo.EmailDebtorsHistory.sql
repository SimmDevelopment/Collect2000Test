CREATE TABLE [dbo].[EmailDebtorsHistory]
(
[EmailId] [int] NOT NULL,
[DebtorId] [int] NOT NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusCd] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL,
[Primary] [bit] NOT NULL,
[ConsentGiven] [bit] NULL,
[WrittenConsent] [bit] NULL,
[ConsentSource] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsentBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsentDate] [datetime] NULL,
[CreatedWhen] [datetime] NOT NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedWhen] [datetime] NOT NULL,
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
