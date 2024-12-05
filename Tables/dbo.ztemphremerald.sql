CREATE TABLE [dbo].[ztemphremerald]
(
[PRIMARY_SSN_ID] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOC_ACCOUNT] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_LINE_1_TXT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_LINE_2_TXT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POSTAL_CD] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOME_PHONE_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
