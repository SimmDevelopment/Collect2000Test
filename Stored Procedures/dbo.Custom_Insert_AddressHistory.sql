SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_Insert_AddressHistory]
@Number int,
@DebtorID int,
@User varchar(50),
@OldStreet1 varchar(50) = '',
@OldStreet2 varchar(50) = '',
@OldCity varchar(50) = '',
@OldState varchar(50) = '',
@OldZipCode varchar(50) = '',
@NewStreet1 varchar(50) ='',
@NewStreet2 varchar(50) = '',
@NewCity varchar(50) = '',
@NewState varchar(50) = '',
@NewZipCode varchar(50) = ''
AS

Insert into AddressHistory (AccountID, DebtorID, DateChanged, UserChanged, OldStreet1,
OldStreet2, OldCity, OldState, OldZipCode, NewStreet1, NewStreet2, NewCity, NewState, 
NewZipCode, TransmittedDate) VALUES (@Number, @DebtorID, GetDate(), @User, @OldStreet1,
@OldStreet2, @OldCity, @OldState, @OldZipCode, @NewStreet1, @NewStreet2, @NewCity, 
@NewState, @NewZipCode, null)

GO
