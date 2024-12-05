SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
DECLARE @number int
SET @number = 500
EXECUTE [Custom_Reactivate] @number
*/
-- =============================================
-- Author: Jeff Mixon
-- Date: 02/13/2007
-- Description: Reactivate closed accounts for Commerce interface
-- =============================================
CREATE  PROCEDURE [dbo].[Custom_Commerce_Reactivate]
            @number as int
AS
BEGIN

            DECLARE @received DATETIME 
            DECLARE @original MONEY 
            DECLARE @original1 MONEY 
            DECLARE @original2 MONEY 
            DECLARE @original3 MONEY 
            DECLARE @original4 MONEY 
            DECLARE @original5 MONEY 
            DECLARE @original6 MONEY 
            DECLARE @original7 MONEY 
            DECLARE @original8 MONEY 
            DECLARE @original9 MONEY 
            DECLARE @original10 MONEY 
            DECLARE @current0 MONEY
            DECLARE @current1 MONEY
            DECLARE @current2 MONEY
            DECLARE @current3 MONEY
            DECLARE @current4 MONEY
            DECLARE @current5 MONEY
            DECLARE @current6 MONEY
            DECLARE @current7 MONEY
            DECLARE @current8 MONEY
            DECLARE @current9 MONEY
            DECLARE @current10 MONEY

            --gets info for note          
            SELECT @original = original,@original1 = original1,@original2 = original2,@original3 = original3,
            @original4 = original4,@original5 = original5,@original6 = original6,@original7 = original7,
            @original8 = original8,@original9 = original9,@original10 = original1,@current0 = current0,
            @current1 = current1,@current2 = current2,@current3 = current3,@current4 = current4,@current5 = current5,
            @current6 = current6,@current7 = current7,@current8 = current8,@current9 = current9,@current10 = current10
            FROM master m WITH(NOLOCK)
            WHERE m.number = @number

            UPDATE MASTER SET
                         CLOSED = NULL
                        ,RETURNED = NULL
                        ,STATUS = 'NEW'
                        ,QLEVEL = '015'
                        ,QDATE = Convert(varchar(8),getdate(),112)
                        ,RECEIVED = CONVERT(DateTime, CONVERT(CHAR,GETDATE(), 103),103)
                        ,SYSMONTH = MONTH(CONVERT(DateTime, CONVERT(CHAR,GETDATE(), 103),103))
                        ,SYSYEAR = YEAR(CONVERT(DateTime, CONVERT(CHAR,GETDATE(), 103),103))
                        ,SHOULDQUEUE = 1
                        ,PAID = 0
                        ,PAID1 = 0
                        ,PAID2 = 0
                        ,PAID3 = 0
                        ,PAID4 = 0
                        ,PAID5 = 0
                        ,PAID6 = 0
                        ,PAID7 = 0
                        ,PAID8 = 0
                        ,PAID9 = 0
                        ,PAID10 = 0
                        ,ACCRUED2 = 0
                        ,ACCRUED10 = 0
                        ,CURRENT0 = (CS.CURRENT1 + CS.CURRENT2 + CS.CURRENT4)
                        ,CURRENT1 = CS.CURRENT1
                        ,CURRENT2 = CS.CURRENT2
                        ,CURRENT3 = 0
                        ,CURRENT4 = CS.CURRENT4
                        ,CURRENT5 = 0
                        ,CURRENT6 = 0
                        ,CURRENT7 = 0
                        ,CURRENT8 = 0
                        ,CURRENT9 = 0
                        ,CURRENT10 = 0
                        ,ORIGINAL = (CS.CURRENT1 + CS.CURRENT2 + CS.CURRENT4)
                        ,ORIGINAL1 = CS.CURRENT1
                        ,ORIGINAL2 = CS.CURRENT2
                        ,ORIGINAL3 = 0
                        ,ORIGINAL4 = CS.CURRENT4
                        ,ORIGINAL5 = 0
                        ,ORIGINAL6 = 0
                        ,ORIGINAL7 = 0
                        ,ORIGINAL8 = 0
                        ,ORIGINAL9 = 0
                        ,ORIGINAL10 = 0
            FROM MASTER M WITH(NOLOCK)
            JOIN Custom_Reactivate_Commerce CS WITH(NOLOCK) ON CS.Account = M.ACCOUNT
            WHERE M.NUMBER = @number


            DECLARE @User0 varchar(10)
            DECLARE @Action varchar(6)
            DECLARE @Result varchar(6)
            DECLARE @Comment varchar(5000)
            SET @User0 = 'EXCH'
            SET @Action = '+++++'
            SET @Result = '+++++'
            SET @Comment = 'Acct reassigned, old assign date @received, old original @original, old current @current0'
            EXECUTE [Custom_Insert_Note]  @number  ,@User0  ,@Action  ,@Result  ,@Comment


END
GO
