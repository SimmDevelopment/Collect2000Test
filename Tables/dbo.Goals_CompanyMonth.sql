CREATE TABLE [dbo].[Goals_CompanyMonth]
(
[GoalsCompanyID] [uniqueidentifier] NULL,
[BranchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Month] [smalldatetime] NULL,
[Gross] [money] NOT NULL,
[Fee] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Goals_CompanyMonth] ADD CONSTRAINT [CK_Goals_CompanyMonth] CHECK ((datepart(day,[Month])=(1) AND datepart(hour,[Month])=(0) AND datepart(minute,[Month])=(0)))
GO
ALTER TABLE [dbo].[Goals_CompanyMonth] ADD CONSTRAINT [FK_Goals_CompanyMonth_BranchCodes] FOREIGN KEY ([BranchCode]) REFERENCES [dbo].[BranchCodes] ([Code])
GO
ALTER TABLE [dbo].[Goals_CompanyMonth] ADD CONSTRAINT [FK_Goals_CompanyMonth_Goals_Company] FOREIGN KEY ([GoalsCompanyID]) REFERENCES [dbo].[Goals_Company] ([GoalsCompanyID])
GO
