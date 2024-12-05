SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[Custom_Insert_DebtorAddressChange]
@Number int,
@DebtorID int,
@OldStreet1 varchar(50) = '',
@OldStreet2 varchar(50) = '',
@OldCity varchar(50) = '',
@OldState varchar(50) = '',
@OldZipCode varchar(50) = ''
AS

INSERT INTO NOTES([number],[created],[user0],[action],[result],[Comment])
SELECT	@Number,	
	GETDATE(),
	'EXG',
	'ADDR',
	'CHNG',
	'Debtor(1) was: ' + @OldStreet1 +'   ' + @OldStreet2

INSERT INTO NOTES([number],[created],[user0],[action],[result],[Comment])
SELECT	@Number,	
	GETDATE(),
	'EXG',
	'ADDR',
	'CHNG',
	'                   ' + @OldCity +',' + @OldState + ',' + @OldZipCode


GO
