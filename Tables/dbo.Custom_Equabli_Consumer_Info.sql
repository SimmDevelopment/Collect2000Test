CREATE TABLE [dbo].[Custom_Equabli_Consumer_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactFirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactMiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactLastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactBusinessName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactSuffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nationalIdentificationNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateOfBirth] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateOfDeath] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[serviceBranch] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[militaryStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[activeDutyStartDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[activeDutyEndDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactAlias] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[driversLicenseNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[driversLicenseStateCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preferredLanguage] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isActive] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isAuthorisedPayer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isSCRA] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Consumer_Info] ADD CONSTRAINT [PK_Custom_Equabli_Consumer_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
