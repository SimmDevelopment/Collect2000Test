CREATE TABLE [dbo].[Attunely_Letters]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LetterKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariationCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Line1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Line2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Line3] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_State] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_PostalCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Country_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SentTime] [datetime2] NOT NULL,
[ReturnedTime] [datetime2] NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Letters] ADD CONSTRAINT [PK_Attunely_Letters] PRIMARY KEY CLUSTERED ([AccountKey], [LetterKey]) ON [PRIMARY]
GO
