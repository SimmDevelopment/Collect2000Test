SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertInvoiceGroup]
@invoiceId int,
@groupId int,
@groupTypeId int,
@containedData bit

AS

INSERT INTO AIM_LedgerInvoiceGroup
(LedgerInvoiceID,GroupID,GroupTypeID,ContainedData)
VALUES
(@invoiceId,@groupId,@groupTypeId,@containedData)

GO
