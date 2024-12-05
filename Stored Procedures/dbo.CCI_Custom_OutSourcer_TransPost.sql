SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CCI_Custom_OutSourcer_TransPost] 
@number int

AS
BEGIN

	SET NOCOUNT ON;

DELETE paymentbatchitems
WHERE filenum = @number
AND paid0+paid1+paid2+paid5+paid6=0

UPDATE paymentbatchitems
SET Paid2=Paid1,
	Paid1=0.00,
	Fee2=Fee1,
	Fee1=0.00
WHERE filenum = @number
AND RIGHT(comment,2)='P2'
AND paid0<>0

UPDATE paymentbatchitems
SET Paid5=Paid1,
	Paid1=0.00,
	Fee5=Fee1,
	Fee1=0.00
WHERE filenum = @number
AND RIGHT(comment,2)='P5'
AND paid0<>0

UPDATE paymentbatchitems
SET Paid6=Paid1,
	Paid1=0.00,
	Fee6=Fee1,
	Fee1=0.00
WHERE filenum = @number
AND RIGHT(comment,2)='P6'
AND paid0<>0

END
GO
