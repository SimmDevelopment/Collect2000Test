SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[Custom_InsertBatchDetail]
@batchid int,
@customerreferenceid int,
@message varchar(MAX),
@messagelevelid int,
@tablename varchar(100),
@servicename varchar(100),
@number int,
@amount money,
@customer varchar(10)
as 


Insert into Custom_batchdetail
(customerreferenceid,batchhistoryid,messageid,message,messagelevelid,tablename,servicename,number,Amount,customer)
values
(@customerreferenceid,@batchid,0,@message,@messagelevelid,@tablename,@servicename,@number,@amount,@customer)
GO
