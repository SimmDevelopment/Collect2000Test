CREATE TABLE [dbo].[controlFile]
(
[Company] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone800] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nextdebtor] [int] NULL,
[nextinvoice] [int] NULL,
[nextlink] [int] NULL,
[password] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currentmonth] [smallint] NULL,
[currentyear] [smallint] NULL,
[useroptions] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[userdate1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[userdate2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[userdate3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money4] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money5] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money6] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money7] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money8] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money9] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[money10] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[X1] [int] NULL,
[X2] [int] NULL,
[fees] [money] NULL,
[collections] [money] NULL,
[mtdpdcfees] [money] NULL,
[mtdpdccollections] [money] NULL,
[mtdfees] [money] NULL,
[mtdcollections] [money] NULL,
[ytdfees] [money] NULL,
[ytdcollections] [money] NULL,
[letterrm] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[letterpdc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[letterbp] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Option1] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[backuppath] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SoftwareVersion] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrystalReports] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eomdate] [datetime] NULL,
[LastDayEnd] [datetime] NULL,
[CheckStocks] [image] NULL,
[HomePage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastMatchDate] [datetime] NULL,
[SeedLetterNo] [int] NULL,
[AIMFilesPath] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Images] [image] NULL,
[options] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastDialerRead] [datetime] NULL,
[InvoiceOption1] [bit] NULL,
[InvoiceOption2] [bit] NULL,
[WebBase] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerDate9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOption9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NobleDlrOptions] [smallint] NULL,
[RightFaxServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RightFaxUserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YouGotClaimsID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailServerOut] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomDLLName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerText1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerText2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerText3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerText4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerText5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[passwordsalt] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegionID] [int] NOT NULL CONSTRAINT [DF__ControlFi__Regio__7FEC93EC] DEFAULT (0),
[CustomerValue10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerValue11] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdminAcctEnabled] [bit] NOT NULL CONSTRAINT [def_ControlFile_AdminAcctEnabled] DEFAULT (1),
[images2] [uniqueidentifier] NULL,
[LatitudeInstanceCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__ControlFi__Latit__762EEADF] DEFAULT ('master'),
[GeneralTrustBankID] [int] NULL,
[OperatingTrustBankID] [int] NULL,
[LatitudeCustomerID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [controlfile1] ON [dbo].[controlFile] ([Company]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains all system wide (Global) Latitude settings', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'backuppath'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency City', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Company name', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'Company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CrystalReports'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current processing month for Latitude.  ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'currentmonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current processing year for Latitude.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'currentyear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 1 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 2 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 3 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 4 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 5 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 6 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 7 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 8 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable date field 9 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerDate9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 1 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 2 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 3 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 4 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 5 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 6 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 7 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 8 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable option field 9 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerOption9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable text field 1 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerText1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable text field 2 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerText2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable text field 3 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerText3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable text field 4 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerText4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable text field 5 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerText5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 1 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Added for the My Desk button. If the My Desk button is desired then, set to ''ExecuteProc.exe'' and set customdllname to ''customexeplugin''.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 2 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 3 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 4 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 5 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 6 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 7 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 8 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains Title of Customizable values field 9 for customer information', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'CustomerValue9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Contact E-Mail address', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This date is used to indicate the last posting day for the current month. Used for MTC collections report projections.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'eomdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Fax', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'All customers who do not have a trust account assigned will use this account for deposits. The account assigned initially as the General Trust account (upon upgrade or conversion) will be the bank account with the lowest code (number) assigned. ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'GeneralTrustBankID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique identifier that is assigned to a given customer for use by licensing services and Latitude Sonar', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'LatitudeCustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter generated when a debtor promise becomes past due with no payment received.   ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'letterbp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter generated when a collector enters post dated check (PDC) or draft entry for a debtor account.  Notifies debtor of deposit date. ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'letterpdc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter generated when a collector enters a debtor promise on an account.  Reminds debtors of their payment promise due date and the amount due. ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'letterrm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Network name of the outgoing email server.  This setting must be correct for email letter functions to work.  ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'MailServerOut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 1. Defaulted to Principal and may not be altered', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 1. Defaulted to Transaction Surcharges  and may not be altered', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 2. Defaulted to Interest and may not be altered', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 3.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 4.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 5.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 6.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 7.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 8.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establishes the name for Money Bucket 9.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'money9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number that will be assigned to the next new debtor account.  Each debtor account in Latitude must be assigned a unique number.  ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'nextdebtor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number that will be assigned to the next invoice generated by the Invoices program module.  ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'nextinvoice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number that will be assigned to the next link created. A link number is assigned to groups of debtor accounts that have been linked together. ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'nextlink'
GO
EXEC sp_addextendedproperty N'MS_Description', N'All transaction surcharges will automatically be deposited to this account. You may use the same bank as the General Trust account and the Operating Trust account. The account assigned initially (upon upgrade) will be the bank account with the lowest code (number) assigned. ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'OperatingTrustBankID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sets the Administrator password used when logging into Latitude with system administrator privileges.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'password'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Phone', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Toll Free Phone', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'phone800'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Installed Latitude Software Version Number', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'SoftwareVersion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency State', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Address line 1', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Address line 2', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains title of the custom date defined by user and noted in the Account Date Information option of the work form', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'userdate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains title of the custom date defined by user and noted in the Account Date Information option of the work form', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'userdate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains title of the custom date defined by user and noted in the Account Date Information option of the work form', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'userdate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used to specify the base web address of the IIS server', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'WebBase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number that will be assigned to the next payment batch created for payments entered into Latitude.', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'X2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used for legal accounts. ', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'YouGotClaimsID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'controlFile', 'COLUMN', N'Zipcode'
GO
