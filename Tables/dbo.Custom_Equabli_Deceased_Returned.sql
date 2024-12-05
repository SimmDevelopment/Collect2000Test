CREATE TABLE [dbo].[Custom_Equabli_Deceased_Returned]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LoanID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOD] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Deceased_Returned] ADD CONSTRAINT [PK_Custom_Equabli_Deceased_Returned] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
