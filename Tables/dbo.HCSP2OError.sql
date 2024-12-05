CREATE TABLE [dbo].[HCSP2OError]
(
[Number] [int] NOT NULL,
[Bucket0_29] [money] NOT NULL,
[Bucket30_59] [money] NOT NULL,
[Bucket60_89] [money] NOT NULL,
[Bucket90_119] [money] NOT NULL,
[Bucket120_149] [money] NOT NULL,
[Bucket150_179] [money] NOT NULL,
[Bucket180Plus] [money] NOT NULL,
[Filename] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WhenLoaded] [datetime] NOT NULL
) ON [PRIMARY]
GO
