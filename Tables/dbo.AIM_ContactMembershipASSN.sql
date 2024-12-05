CREATE TABLE [dbo].[AIM_ContactMembershipASSN]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ContactID] [int] NULL,
[MembershipID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ContactMembershipASSN] ADD CONSTRAINT [PK_AIM_ContactMembershipASSN] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ContactMembershipASSN] ADD CONSTRAINT [FK_AIM_ContactMembershipASSN_AIM_Contact] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[AIM_Contact] ([ContactId])
GO
ALTER TABLE [dbo].[AIM_ContactMembershipASSN] ADD CONSTRAINT [FK_AIM_ContactMembershipASSN_AIM_Membership] FOREIGN KEY ([MembershipID]) REFERENCES [dbo].[AIM_Membership] ([ID])
GO
