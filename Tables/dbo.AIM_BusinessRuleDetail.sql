CREATE TABLE [dbo].[AIM_BusinessRuleDetail]
(
[BusinessRuleDetailID] [int] NOT NULL IDENTITY(1, 1),
[BusinessRuleID] [int] NOT NULL,
[AccountFilterID] [int] NOT NULL,
[DistributionTemplateID] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
