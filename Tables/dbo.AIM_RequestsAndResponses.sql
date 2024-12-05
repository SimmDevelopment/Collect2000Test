CREATE TABLE [dbo].[AIM_RequestsAndResponses]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestOrigination] [int] NULL,
[AccountID] [int] NOT NULL,
[AgencyID] [int] NOT NULL,
[RequestID] [int] NOT NULL,
[ResponseID] [int] NULL,
[Requested] [datetime] NOT NULL,
[Responded] [datetime] NULL,
[RequestText] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseText] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutsideRequestID] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_AIM_RequestAndResponse_InsertOrUpdate]
   ON  [dbo].[AIM_RequestsAndResponses] 
   FOR UPDATE,INSERT
AS
BEGIN
if exists(select top 1 a.agencyid
			from inserted i
			join aim_accountreference ar with (nolock) on i.accountid = ar.referencenumber
			join aim_agency a with (nolock) on ar.currentlyplacedagencyid = a.agencyid
			where a.fileformat <> 'YGC' and  ISNULL(RTRIM(LTRIM(a.agencyversion)),'') != '8.2.2')
	begin	
	if not exists(select top 1 accounttransactionid 
	from aim_accounttransaction atr with (nolock)
	join aim_accountreference ar with (nolock)
	on ar.accountreferenceid = atr.accountreferenceid 
	join inserted i 
	on i.accountid = ar.referencenumber  
	where ar.referencenumber = i.accountid 
	and atr.transactiontypeid = 34 and transactionstatustypeid = 1 
	and foreigntableuniqueid = i.id)
		begin
			insert into AIM_accounttransaction (accountreferenceid,transactiontypeid,transactionstatustypeid,
				createddatetime,agencyid,commissionpercentage,balance,foreigntableuniqueid )
			select 
			accountreferenceid,34,1,getdate(),currentlyplacedagencyid,currentcommissionpercentage,current0,i.id 
			from aim_accountreference ar with (nolock)
			join master m with (nolock) on m.number = ar.referencenumber
			join inserted i on i.accountid = m.number 
			where 
			(requestorigination is null and responseid is null)
			 or 
			 (requestorigination is not null and responseid is not null)

		end
	end
END

GO
ALTER TABLE [dbo].[AIM_RequestsAndResponses] ADD CONSTRAINT [PK_AIM_RequestsAndResponses] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
