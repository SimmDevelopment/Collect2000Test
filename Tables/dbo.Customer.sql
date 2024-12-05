CREATE TABLE [dbo].[Customer]
(
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[status] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SelectedFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lettercode] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[penalty] [money] NULL,
[badcheck] [money] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fees] [money] NULL,
[collections] [money] NULL,
[mtdnumberplaced] [float] NULL,
[mtddollarsplaced] [money] NULL,
[ytdnumberplaced] [float] NULL,
[ytddollarsplaced] [money] NULL,
[mtdpdcfees] [money] NULL,
[mtdpdccollections] [money] NULL,
[mtdfees] [money] NULL,
[mtdcollections] [money] NULL,
[ytdfees] [money] NULL,
[ytdcollections] [money] NULL,
[bankcode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attorneycode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesmancode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sifinfo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workinfo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[miscinfo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoicetype] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoicefreq] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoicesort] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoicemethod] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[options] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[option1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fax] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Half] [money] NULL,
[Close_] [money] NULL,
[FaxNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoRecallStatus] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoRecallDays] [int] NULL,
[AutoRecallFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[locate] [money] NULL,
[SpecialCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerGroup] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full0] [money] NULL,
[AmtDueClient] [smallint] NULL,
[feecode2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[feedays] [int] NULL,
[cob] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastInvoiceAttempt] [datetime] NULL,
[RemitMethod] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ABARoutingNum] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankAcctNum] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustGroup] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckHoldDays] [smallint] NULL CONSTRAINT [DF_Customer_CheckHoldDays] DEFAULT (0),
[InvShowRcvd] [bit] NULL CONSTRAINT [DF_Customer_InvShowRcvd] DEFAULT (0),
[InvShowBal] [bit] NULL CONSTRAINT [DF_Customer_InvShowBal] DEFAULT (0),
[CCostPct] [float] NULL,
[CCostBucket] [tinyint] NULL,
[FeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPODCust] [bit] NULL,
[CBRRptType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CBRMinBal] [money] NULL CONSTRAINT [DF_Customer_CBRMinBal] DEFAULT (0),
[CBRWaitDays] [int] NULL CONSTRAINT [DF_Customer_CBRWaitDays] DEFAULT (0),
[UseEquifax] [bit] NULL CONSTRAINT [DF_Customer_UseEq] DEFAULT (0),
[UseTransUnion] [bit] NULL CONSTRAINT [DF_Customer_UseTU] DEFAULT (0),
[UseExperian] [bit] NULL CONSTRAINT [DF_Customer_UseExp] DEFAULT (0),
[UseInnovis] [bit] NULL CONSTRAINT [DF_Customer_UseInn] DEFAULT (0),
[eMail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CBRClass] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShowReverseOfDate] [bit] NULL,
[OnlineCheckFee] [money] NULL,
[AlphaCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sweep] [bit] NULL,
[SweepDays] [int] NULL,
[SweepDaysPaid] [int] NULL,
[SweepMinBalance] [money] NULL,
[SweepDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CbrAcctRtnSendDel] [bit] NULL,
[CustomDate1] [datetime] NULL,
[CustomDate2] [datetime] NULL,
[CustomDate3] [datetime] NULL,
[CustomDate4] [datetime] NULL,
[CustomDate5] [datetime] NULL,
[CustomDate6] [datetime] NULL,
[CustomDate7] [datetime] NULL,
[CustomDate8] [datetime] NULL,
[CustomDate9] [datetime] NULL,
[CustomOption1] [bit] NULL,
[CustomOption2] [bit] NULL,
[CustomOption3] [bit] NULL,
[CustomOption4] [bit] NULL,
[CustomOption5] [bit] NULL,
[CustomOption6] [bit] NULL,
[CustomOption7] [bit] NULL,
[CustomOption8] [bit] NULL,
[CustomOption9] [bit] NULL,
[CustomValue1] [int] NULL,
[CustomValue2] [int] NULL,
[CustomValue3] [int] NULL,
[CustomValue4] [int] NULL,
[CustomValue5] [int] NULL,
[CustomValue6] [int] NULL,
[CustomValue7] [int] NULL,
[CustomValue8] [int] NULL,
[CustomValue9] [int] NULL,
[LegalFeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CCustomerID] [int] NOT NULL IDENTITY(1, 1),
[LetterDeliveryMethod] [int] NOT NULL CONSTRAINT [DF_Customer_LetterDeliveryMethod] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Customer_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_Customer_DateUpdated] DEFAULT (getdate()),
[FeeCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BlanketSif] [float] NULL CONSTRAINT [DF_Customer_BlanketSif] DEFAULT (1),
[IsPrincipleCust] [bit] NOT NULL CONSTRAINT [DF__Customer__IsPrin__033D368C] DEFAULT (0),
[CustomText1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomText2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomText3] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomText4] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomText5] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankID] [int] NULL,
[DefaultInterest] [float] NOT NULL CONSTRAINT [DF__Customer__DefaultInterest] DEFAULT ((0)),
[InvShowOther] [bit] NULL,
[AcknowledgeNewBiz] [bit] NOT NULL CONSTRAINT [DF__Customer__Acknow__61081A19] DEFAULT (1),
[Salesman1ID] [int] NOT NULL CONSTRAINT [DF__Customer__Salesm__7E6372D6] DEFAULT (0),
[Salesman2ID] [int] NOT NULL CONSTRAINT [DF__Customer__Salesm__7F57970F] DEFAULT (0),
[Salesman3ID] [int] NOT NULL CONSTRAINT [DF__Customer__Salesm__004BBB48] DEFAULT (0),
[CollectorFeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CbrOriginalCreditor] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CbrAccountType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CbrCreditorClass] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeCapAmount] [money] NOT NULL CONSTRAINT [DF__customer__FeeCap__4852463F] DEFAULT (0.0),
[FeeCapPercent] [real] NOT NULL CONSTRAINT [DF__customer__FeeCap__49466A78] DEFAULT (0.0),
[InvoiceReport] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__customer__Invoic__4A3A8EB1] DEFAULT ('BasicInvoice.rpt'),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__customer__Create__4B2EB2EA] DEFAULT (suser_sname()),
[UpdatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__customer__Update__4C22D723] DEFAULT (suser_sname()),
[FreeDemandDays] [tinyint] NOT NULL CONSTRAINT [DF__customer__FreeDe__5D4D6325] DEFAULT (0),
[FreeDemandBatchTypes] [tinyint] NOT NULL CONSTRAINT [DF__customer__FreeDe__5E41875E] DEFAULT (0),
[CultureCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestBuckets] [smallint] NULL,
[Priority] [tinyint] NOT NULL CONSTRAINT [def_customer_Priority] DEFAULT ((5)),
[PermitSurcharges] [bit] NOT NULL CONSTRAINT [DF__Customer__Permit__2CBDA3B5] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*ALTER  Trigger Customer_Audit_UTrig  */
CREATE      TRIGGER [dbo].[Customer_Audit_UTrig]
ON [dbo].[Customer]
FOR UPDATE
NOT FOR REPLICATION

AS
SET NOCOUNT ON
DECLARE @User VARCHAR(256);

SELECT @User = [LoginName]
FROM [dbo].[GetCurrentLatitudeUser]();

IF @User IS NULL
	SET @User = USER_NAME();

IF UPDATE(UpdatedBy)
	UPDATE [dbo].[Customer]
	SET [DateUpdated] = GETDATE()
	FROM [dbo].[Customer]
	INNER JOIN INSERTED
	ON INSERTED.customer = [Customer].[customer];
ELSE
	UPDATE [dbo].[Customer]
	SET [DateUpdated] = GETDATE(), [UpdatedBy] = @User
	FROM [dbo].[Customer]
	INNER JOIN INSERTED
	ON INSERTED.customer = [Customer].[customer];

IF UPDATE(Name)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Name changed from ' + deleted.Name + ' to ' + inserted.Name,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.Name <> deleted.Name

IF UPDATE(AlphaCode)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Alpha Code changed from ' + deleted.AlphaCode + ' to ' + inserted.AlphaCode,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.AlphaCode <> deleted.AlphaCode

IF UPDATE(status)
	INSERT CustomerComments
	SELECT inserted.customer,
		'status changed from ' + deleted.status + ' to ' + inserted.status,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.status <> deleted.status

IF UPDATE(Street1)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Street1 changed from ' + deleted.Street1 + ' to ' + inserted.Street1,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.Street1 <> deleted.Street1

IF UPDATE(Street2)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Street2 changed from ' + deleted.Street2 + ' to ' + inserted.Street2,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.Street2 <> deleted.Street2

IF UPDATE(City)
	INSERT CustomerComments
	SELECT inserted.customer,
		'City changed from ' + deleted.City + ' to ' + inserted.City,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.City <> deleted.City

IF UPDATE(State)
	INSERT CustomerComments
	SELECT inserted.customer,
		'State changed from ' + deleted.State + ' to ' + inserted.State,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.State <> deleted.State

IF UPDATE(Zipcode)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Zipcode changed from ' + deleted.Zipcode + ' to ' + inserted.Zipcode,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.Zipcode <> deleted.Zipcode

IF UPDATE(Contact)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Contact changed from ' + deleted.Contact + ' to ' + inserted.Contact,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.Contact <> deleted.Contact

IF UPDATE(phone)
	INSERT CustomerComments
	SELECT inserted.customer,
		'phone changed from ' + deleted.phone + ' to ' + inserted.phone,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.phone <> deleted.phone

IF UPDATE(faxnumber)
	INSERT CustomerComments
	SELECT inserted.customer,
		'faxnumber changed from ' + deleted.faxnumber + ' to ' + inserted.faxnumber,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.faxnumber <> deleted.faxnumber

IF UPDATE(lettercode)
	INSERT CustomerComments
	SELECT inserted.customer,
		'lettercode changed from ' + deleted.lettercode + ' to ' + inserted.lettercode,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.lettercode <> deleted.lettercode

IF UPDATE(penalty)
	INSERT CustomerComments
	SELECT inserted.customer,
		'penalty changed from ' + convert(varchar(50), deleted.penalty) + ' to ' + convert(varchar(50), inserted.penalty),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.penalty <> deleted.penalty

IF UPDATE(badcheck)
	INSERT CustomerComments
	SELECT inserted.customer,
		'badcheck changed from ' + convert(varchar(50), deleted.badcheck) + ' to ' + convert(varchar(50), inserted.badcheck),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.badcheck <> deleted.badcheck

IF UPDATE(bankcode)
	INSERT CustomerComments
	SELECT inserted.customer,
		'bankcode changed from ' + deleted.bankcode + ' to ' + inserted.bankcode,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.bankcode <> deleted.bankcode

IF UPDATE(attorneycode)
	INSERT CustomerComments
	SELECT inserted.customer,
		'attorneycode changed from ' + deleted.attorneycode + ' to ' + inserted.attorneycode,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.attorneycode <> deleted.attorneycode

IF UPDATE(salesmancode)
	INSERT CustomerComments
	SELECT inserted.customer,
		'salesmancode changed from ' + deleted.salesmancode + ' to ' + inserted.salesmancode,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.salesmancode <> deleted.salesmancode

/* sifinfo, workinfo, and miscinfo are of the text datatype which is
   not supported in inserted and deleted tables
IF UPDATE(sifinfo)
	INSERT CustomerComments
	SELECT inserted.customer,
		'sifinfo changed from ' + deleted.sifinfo + ' to ' + inserted.sifinfo,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.sifinfo <> deleted.sifinfo

IF UPDATE(workinfo)
	INSERT CustomerComments
	SELECT inserted.customer,
		'workinfo changed from ' + deleted.workinfo + ' to ' + inserted.workinfo,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.workinfo <> deleted.workinfo

IF UPDATE(miscinfo)
	INSERT CustomerComments
	SELECT inserted.customer,
		'miscinfo changed from ' + deleted.miscinfo + ' to ' + inserted.miscinfo,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.miscinfo <> deleted.miscinfo
*/
IF UPDATE(invoicetype)
	INSERT CustomerComments
	SELECT inserted.customer,
		'invoicetype changed from ' + deleted.invoicetype + ' to ' + inserted.invoicetype,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.invoicetype <> deleted.invoicetype

IF UPDATE(invoicefreq)
	INSERT CustomerComments
	SELECT inserted.customer,
		'invoicefreq changed from ' + deleted.invoicefreq + ' to ' + inserted.invoicefreq,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.invoicefreq <> deleted.invoicefreq

IF UPDATE(invoicesort)
	INSERT CustomerComments
	SELECT inserted.customer,
		'invoicesort changed from ' + deleted.invoicesort + ' to ' + inserted.invoicesort,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.invoicesort <> deleted.invoicesort

IF UPDATE(invoicemethod)
	INSERT CustomerComments
	SELECT inserted.customer,
		'invoicemethod changed from ' + deleted.invoicemethod + ' to ' + inserted.invoicemethod,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.invoicemethod <> deleted.invoicemethod

IF UPDATE(cob)
	INSERT CustomerComments
	SELECT inserted.customer,
		'cob changed from ' + deleted.cob + ' to ' + inserted.cob,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.cob <> deleted.cob

IF UPDATE(remitmethod)
	INSERT CustomerComments
	SELECT inserted.customer,
		'remitmethod changed from ' + deleted.remitmethod + ' to ' + inserted.remitmethod,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.remitmethod <> deleted.remitmethod

IF UPDATE(custgroup)
	INSERT CustomerComments
	SELECT inserted.customer,
		'custgroup changed from ' + deleted.custgroup + ' to ' + inserted.custgroup,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.custgroup <> deleted.custgroup

IF UPDATE(checkholddays)
	INSERT CustomerComments
	SELECT inserted.customer,
		'checkholddays changed from ' + convert(varchar(50), deleted.checkholddays) + ' to ' + convert(varchar(50), inserted.checkholddays),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.checkholddays <> deleted.checkholddays

IF UPDATE(ccostpct)
	INSERT CustomerComments
	SELECT inserted.customer,
		'ccostpct changed from ' + convert(varchar(50), deleted.ccostpct) + ' to ' + convert(varchar(50), inserted.ccostpct),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.ccostpct <> deleted.ccostpct

IF UPDATE(ccostbucket)
	INSERT CustomerComments
	SELECT inserted.customer,
		'ccostbucket changed from ' + convert(varchar(50), deleted.ccostbucket) + ' to ' + convert(varchar(50), inserted.ccostbucket),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.ccostbucket <> deleted.ccostbucket

IF UPDATE(feeschedule)
	INSERT CustomerComments
	SELECT inserted.customer,
		'feeschedule changed from ' + deleted.feeschedule + ' to ' + inserted.feeschedule,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.feeschedule <> deleted.feeschedule

IF UPDATE(cbrrpttype)
	INSERT CustomerComments
	SELECT inserted.customer,
		'cbrrpttype changed from ' + deleted.cbrrpttype + ' to ' + inserted.cbrrpttype,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.cbrrpttype <> deleted.cbrrpttype

IF UPDATE(cbrclass)
	INSERT CustomerComments
	SELECT inserted.customer,
		'cbrclass changed from ' + deleted.cbrclass + ' to ' + inserted.cbrclass,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.cbrclass <> deleted.cbrclass

IF UPDATE(cbrminbal)
	INSERT CustomerComments
	SELECT inserted.customer,
		'cbrminbal changed from ' + convert(varchar(50),deleted.cbrminbal) + ' to ' + convert(varchar(50),inserted.cbrminbal),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.cbrminbal <> deleted.cbrminbal

IF UPDATE(cbrwaitdays)
	INSERT CustomerComments
	SELECT inserted.customer,
		'cbrwaitdays changed from ' + convert(varchar(50),deleted.cbrwaitdays) + ' to ' + convert(varchar(50),inserted.cbrwaitdays),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.cbrwaitdays <> deleted.cbrwaitdays

IF UPDATE(useequifax)
	INSERT CustomerComments
	SELECT inserted.customer,
		'useequifax changed from ' + convert(varchar(50),deleted.useequifax) + ' to ' + convert(varchar(50),inserted.useequifax),
             	getdate(),
		@User
       FROM inserted, deleted
     WHERE inserted.customer = deleted.customer
       AND inserted.useequifax <> deleted.useequifax

IF UPDATE(usetransunion)
	INSERT CustomerComments
	SELECT inserted.customer,
		'usetransunion changed from ' + convert(varchar(50),deleted.usetransunion) + ' to ' + convert(varchar(50),inserted.usetransunion),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.usetransunion <> deleted.usetransunion

IF UPDATE(useexperian)
	INSERT CustomerComments
	SELECT inserted.customer,
		'useexperian changed from ' + convert(varchar(50),deleted.useexperian) + ' to ' + convert(varchar(50),inserted.useexperian),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.useexperian <> deleted.useexperian

IF UPDATE(useinnovis)
	INSERT CustomerComments
	SELECT inserted.customer,
		'useinnovis changed from ' + convert(varchar(50),deleted.useinnovis) + ' to ' + convert(varchar(50),inserted.useinnovis),
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.useinnovis <> deleted.useinnovis

IF UPDATE(email)
	INSERT CustomerComments
	SELECT inserted.customer,
		'email changed from ' + deleted.email + ' to ' + inserted.email,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.email <> deleted.email

IF UPDATE(CbrOriginalCreditor)
	INSERT CustomerComments
	SELECT inserted.customer,
		'CBR Original Creditor changed from ' + deleted.CbrOriginalCreditor + ' to ' + inserted.CbrOriginalCreditor,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.CbrOriginalCreditor <> deleted.CbrOriginalCreditor

IF UPDATE(CbrAccountType)
	INSERT CustomerComments
	SELECT inserted.customer,
		'CBR Account Type from ' + deleted.CbrAccountType + ' to ' + inserted.CbrAccountType,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.CbrAccountType <> deleted.CbrAccountType

IF UPDATE(CbrCreditorClass)
	INSERT CustomerComments
	SELECT inserted.customer,
		'CBR Creditor Class changed from ' + deleted.CbrCreditorClass + ' to ' + inserted.CbrCreditorClass,
             	getdate(),
		@User
       FROM inserted, deleted
       WHERE inserted.customer = deleted.customer
       AND inserted.CbrCreditorClass <> deleted.CbrCreditorClass

IF UPDATE(Priority)
	INSERT CustomerComments
	SELECT inserted.customer,
		'Priority changed from ' + CAST(deleted.Priority AS VARCHAR(4)) + ' to ' + CAST(inserted.Priority AS VARCHAR(4)),
		GETDATE(),
		@User
	FROM inserted
	INNER JOIN deleted
	ON inserted.customer = deleted.customer
	AND inserted.Priority <> deleted.Priority;

--SELECT @MsgTxt = 'New = ' + inserted.customername
--print @MsgTxt

	-- insert comment
--	INSERT INTO CustomerComments (CustomerCode, Comment, CreatedBy)
--	VALUES ( @Code, @MsgTxt , @User)





GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [uq_Customer_CCustomerID] UNIQUE NONCLUSTERED ([CCustomerID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Customer1] ON [dbo].[Customer] ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_InvFreq] ON [dbo].[Customer] ([invoicefreq]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SpecialCode] ON [dbo].[Customer] ([SpecialCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer or Portfolio for placed and or owned accounts', 'SCHEMA', N'dbo', 'TABLE', N'Customer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set will include this customer''s accounts when generating acknowledgement reports ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'AcknowledgeNewBiz'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined generic code which can be used to relate the Agencies customer to the Client, Previous collection system or any other grouping or cross reference.', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'AlphaCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'badcheck'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code representing the trust account used by your collection agency for this customer if your agency will be printing checks for the customer using Latitude ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'bankcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bank Identity Key of Trust Bank for Customer', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'BankID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percent of balance customer will allow to consider a debtor account as settled i', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'BlanketSif'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account type reported to the Bureau, configured with CBR Reporting Console.  48 - Collection Agency/Attorney 77 - Returned Check 0C - Factoring Company Account/Debt Purchaser ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CbrAccountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to send delete (DA) to credit bureau is account has been previously reported and account is returned to Client.', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CbrAcctRtnSendDel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a code indicating a general type of business for the Original Creditor Name. Values available: 01 Retail 02 Medical/Health Care 03 Oil Company 04 Government 05 Personal Services 06 Insurance 07 Educational 08 Banking 09 Rental/Leasing 10 Utilities 11 Cable/Cellular 12 Financial 13 Credit Union 14 Automotive 15 Check Guarantee', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CBRClass'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a code indicating a general type of business for the Original Creditor Name. Values available: 01 Retail 02 Medical/Health Care 03 Oil Company 04 Government 05 Personal Services 06 Insurance 07 Educational 08 Banking 09 Rental/Leasing 10 Utilities 11 Cable/Cellular 12 Financial 13 Credit Union 14 Automotive 15 Check Guarantee', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CbrCreditorClass'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit Reporting Option - minimum balance to report ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CBRMinBal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the company or agent who originally opened the account for the consumer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CbrOriginalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit Reporting Option - report type ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CBRRptType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit Reporting Option - number of days to wait before reporting ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CBRWaitDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Money Bucket (3..9)  to be used for add on collection costs', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CCostBucket'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percent to be added to accounts for collection costs during placement of accounts', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CCostPct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CCustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days to wait before including debtor payments on a customer invoice.  ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CheckHoldDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing City of Customer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Class of business as defined and available from the COB table', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'cob'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total collections  made', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'collections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains collector fee code which is used to display fee information to users who do not have view fee privileges.', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CollectorFeeSchedule'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Company name of Customer', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Person to contact at the customer office ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Contact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Windows culture code (customer.CultureCode can be set to this to set the culture of the customer to display alternate currencies)', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CultureCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom Invoice Group (Parent Customer) ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustGroup'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 1 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 2 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 3 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 4 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 5 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 6 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 7 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 8 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer date field 9 ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomDate9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer code that identifies the customer or portfolio.  Application generated or User defined.  Latitude reports, Consoles and lookup queries will use this code to access and report on customer accounts.', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 1', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 2', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 3', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 4', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 5', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 6', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 7', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 8', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer option field 9', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomOption9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom data stored for the customer in the Text1 field of Customer properties. ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomText1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom data stored for the customer in the Text2 field of Customer properties ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomText2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom data stored for the customer in the Text3 field of Customer properties ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomText3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom data stored for the customer in the Text4 field of Customer properties ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomText4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom data stored for the customer in the Text5field of Customer properties ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomText5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 1', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 2', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 3', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 4', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 5', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 6', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 7', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 8', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom agency customer value field 9', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'CustomValue9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp od last update', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default desk to assign new business', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'DefaultDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interest rate to be applied to respective accounts when placed', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'DefaultInterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude Fax Imaging Program identifier ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'FaxID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When populated this will stop applying fees to applicable buckets after the fee cap amount is reached', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'FeeCapAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When populated this will stop applying fees to applicable buckets after the fee cap percent is reached', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'FeeCapPercent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total fees earned', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'fees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Fee Schedule for Accounts ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'FeeSchedule'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 = PU, 2 = PC, 4 = PA (for combinations sum total is used)', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'FreeDemandBatchTypes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number of grace days granted to a customer when new business is received.  Fees will not be applied to the payment types defined in FreeDemandBatchTypes for the number of Free Demand Days indicated', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'FreeDemandDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates frequency to invoice customer (monthly, weekly, on demand) ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'invoicefreq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates how client is invoiced: Net - Select to net your fee from the customer invoice.  Customer invoices will be sent minus your agencys fee. NOTE: If you set the Invoice Type to Combined, PC (direct) payments will be included in the fees withheld.  If Invoice Type is set to Separate, PC (direct) payments will be created as open items for the invoice.   Gross - Select to send customer invoices with all monies included.  The customer will pay your fee based on the invoice information ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'invoicemethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Crystal report file to use when creating invoices for the customer.  This allows', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'InvoiceReport'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoicesort - (1) Account Name , Sort by debtor name. (2) Customer Account , sort by customer account number for the debtor', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'invoicesort'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates separate or combined (with parent customer) invoicing method.            (1) Separate: Used to divide payment types and create separate invoices for each payment type for the customer.    (2) Combined: Used to include all payment types together (combined) in one customer invoice.  ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'invoicetype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Print the current debtor balance on the customer invoice ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'InvShowBal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Print the debtors other name on the customer invoice', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'InvShowOther'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Print date payments were received on the customer invoice ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'InvShowRcvd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to indicate if customer uses particulars of debt ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'IsPODCust'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator that is set if this customer record holds accounts that are owned by your agency, as opposed to only held by your agency for collection purposes', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'IsPrincipleCust'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of last invoice attempt, whether invoice was created or not ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'LastInvoiceAttempt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Fee schedule for accounts assigned to attorney/forwarder ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'LegalFeeSchedule'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default lettercode for new accounts ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'lettercode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer miscellaneous guidelines or information ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'miscinfo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date collections', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'mtdcollections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date dollars (oriignal amount) placed', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'mtddollarsplaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date fees', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'mtdfees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date accounts placed', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'mtdnumberplaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date pdc collected amount', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'mtdpdccollections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date pdc fees earned', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'mtdpdcfees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Company name or customer name ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer contacts phone number ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manual - Your agency manually generates a check for the customer. Check - Your agency uses the Invoices program to print a check for the customer. ACH Transfer - Your agency uses the Invoices program to create an ACH wire transfer for the customer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'RemitMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Primary salesman handling this customer account', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Salesman1ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of additional salesman handling this customer account', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Salesman2ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of additional salesman handling this customer account', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Salesman3ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code of salesman handling this customer account ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'salesmancode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Print the original payment date on the customer invoice ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'ShowReverseOfDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer''s settlement in full guidelines', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'sifinfo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing State of Customer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ACTIVE or INACTIVE', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing Street Address 1 of Customer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing Street Address 2 of Customer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set allows respective accounts to participate in sweep.', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Sweep'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days old an account must be before sweeping is allowed', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'SweepDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days past the payment date to begin sweep', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'SweepDaysPaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk (queue) that will hold all accounts swept based on criteria', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'SweepDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum balance allowed on accounts that are swept into the desk  or queue', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'SweepMinBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer''s work account guidelines', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'workinfo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year to date collections', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'ytdcollections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year to date dollars placed', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'ytddollarsplaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year to date fees', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'ytdfees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year to date accounts placed', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'ytdnumberplaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing Zipcode of Customer ', 'SCHEMA', N'dbo', 'TABLE', N'Customer', 'COLUMN', N'Zipcode'
GO
