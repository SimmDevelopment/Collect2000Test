SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_Post_Financials] 
@number int

AS
BEGIN

	SET NOCOUNT ON;

DELETE 
FROM paymentbatchitems
WHERE filenum = @number
AND paid0+paid1+paid2+paid3+paid4=0


UPDATE paymentbatchitems
SET fee0 = case when checknumber = '0' then 0.00 else Fee0 END,
	fee1 = case when checknumber = '0' then 0.00 else Fee1 END,
	CollectorFee = case when checknumber = '0' then 0.00 else Fee0 END
WHERE filenum = @number
AND RIGHT(comment,2)='P1'
AND paid0<>0

UPDATE paymentbatchitems
SET Paid2=Paid1,
	Paid1=0.00,
	fee2 = case when checknumber = '0' then 0.00 else Fee1 END,
	Fee1=0.00,
	fee0 = case when checknumber = '0' then 0.00 else Fee0 END,
	CollectorFee = case when checknumber = '0' then 0.00 else Fee1 END
WHERE filenum = @number
AND RIGHT(comment,2)='P2'
AND paid0<>0

UPDATE paymentbatchitems
SET Paid3=Paid1,
	Paid1=0.00,
	fee3 = case when checknumber = '0' then 0.00 else Fee1 END,
	Fee1=0.00,
	fee0 = case when checknumber = '0' then 0.00 else Fee0 END,
	CollectorFee = case when checknumber = '0' then 0.00 else Fee1 END
WHERE filenum = @number
AND RIGHT(comment,2)='P3'
AND paid0<>0

UPDATE paymentbatchitems
SET Paid4=Paid1,
	Paid1=0.00,
	fee4 = case when checknumber = '0' then 0.00 else Fee1 END,
	Fee1=0.00,
	fee0 = case when checknumber = '0' then 0.00 else Fee0 END,
	CollectorFee = case when checknumber = '0' then 0.00 else Fee1 END
WHERE filenum = @number
AND RIGHT(comment,2)='P4'
AND paid0<>0

END
GO
