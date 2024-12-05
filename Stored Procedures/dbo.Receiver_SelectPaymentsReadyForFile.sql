SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[Receiver_SelectPaymentsReadyForFile]
@invoices varchar(8000),
@clientid int,
@sendAdjustments bit
as
BEGIN

	declare @sql varchar(8000)
	declare @lastFileSentDT datetime
	select @lastFileSentDT = dbo.Receiver_GetLastFileDate(6,@clientid)

	DECLARE @AIMClientVersion varchar(10)
	DECLARE @UseNewSchema bit
	
	SELECT @AIMClientVersion = [AIMClientVersion]
	FROM Receiver_Client WHERE ClientID = @clientid
	
	IF(RTRIM(LTRIM(@AIMClientVersion)) = '8.3.*' OR RTRIM(LTRIM(@AIMClientVersion)) IN ('10.7' ,'10.8'))
	BEGIN
		SET @UseNewSchema = 1
	END
	ELSE
	BEGIN
		SET @UseNewSchema = 0
	END
	
	-- Added by KAR on 05/11/2011 Need to handle the OverPaymentAmount flag. Default to True as to now
	DECLARE @sendOverPayments bit
	select @sendOverPayments = ISNULL(SendOverpaidAmount,1)
	FROM Receiver_Client WHERE ClientID = @clientid

	DECLARE @paymentString varchar(500)
	
	SELECT @paymentString	='dbo.Custom_CalculatePaymentTotalPaid(p.uid)  + ' + 
	CASE @sendOverPayments WHEN 1 THEN ' isnull(p.OverPaidAmt,0)'  ELSE '0.00' END + ' as payment_amount,'
	--SELECT @paymentString

	/*<record recordType="APAY" dataTableName="PaymentRecord" width="447" key="record_type">
	<column name="record_type" dataType="string" width="4" />
	<column name="file_number" dataType="int" width="9" />
	<column name="account" dataType="string" width="30" />
	<column name="payment_amount" dataType="decimal" width="12" />
	<column name="payment_date" dataType="dateTime" width="8" />
	<column name="payment_type" dataType="string" width="3" />
	<column name="payment_identifier" dataType="string" width="30" />
	<column name="comment" dataType="string" width="30" />
	<column name="payment_amount_bucket1" dataType="decimal" width="12" />
	<column name="payment_amount_bucket2" dataType="decimal" width="12" />
	<column name="payment_amount_bucket3" dataType="decimal" width="12" />
	<column name="payment_amount_bucket4" dataType="decimal" width="12" />
	<column name="payment_amount_bucket5" dataType="decimal" width="12" />
	<column name="payment_amount_bucket6" dataType="decimal" width="12" />
	<column name="payment_amount_bucket7" dataType="decimal" width="12" />
	<column name="payment_amount_bucket8" dataType="decimal" width="12" />
	<column name="payment_amount_bucket9" dataType="decimal" width="12" />
	<column name="payment_method" dataType="string" width="30" />
	<column name="is_SIF" dataType="string" width="1" />
	<column name="fee_amount" dataType="decimal" width="12" />
	<column name="fee_amount_bucket1" dataType="decimal" width="12" />
	<column name="fee_amount_bucket2" dataType="decimal" width="12" />
	<column name="fee_amount_bucket3" dataType="decimal" width="12" />
	<column name="fee_amount_bucket4" dataType="decimal" width="12" />
	<column name="fee_amount_bucket5" dataType="decimal" width="12" />
	<column name="fee_amount_bucket6" dataType="decimal" width="12" />
	<column name="fee_amount_bucket7" dataType="decimal" width="12" />
	<column name="fee_amount_bucket8" dataType="decimal" width="12" />
	<column name="fee_amount_bucket9" dataType="decimal" width="12" />
	<column name="remit_amount" dataType="decimal" width="12" />
	<column name="invoice_identifier" dataType="string" width="50" />
	*/

	IF(@UseNewSchema = 0) 
	BEGIN
		set @sql = '
		SELECT
            ''APAY'' as record_type,
            r.sendernumber as file_number,
            m.account as account, ' +
            --dbo.Custom_CalculatePaymentTotalPaid(p.uid)+ isnull(p.OverPaidAmt,0) as payment_amount,--
			@paymentString + 
            'p.datepaid as payment_date,
            ''payment_type'' =
            case  p.batchtype
            when ''PU'' then ''PA''
            when ''PUR'' then ''PAR''
            when ''PA'' then ''PA''
            when ''PAR'' then ''PAR''
            end,
            p.uid as payment_identifier,
            p.comment as comment
        FROM
            payhistory p  with (nolock) join master m  with (nolock) on p.number = m.number
                join receiver_reference r  with (nolock) on r.receivernumber = m.number
        WHERE 
            r.clientid = ' + cast(@clientid as varchar(10)) + '
            and
            p.invoice in (' + @invoices+')
            and 
            p.batchtype not in (''PC'',''PCR'')'
	 
		-- Are we sending adjustments?
		IF(@sendAdjustments = 1)	 
		BEGIN
			set @sql = @sql + '  
            UNION
            SELECT
                ''APAY'' as record_type,
                r.sendernumber as file_number,
                m.account as account,
                p.totalpaid as payment_amount,
                p.datepaid as payment_date,
                ''payment_type'' =
                case when p.subbatchtype is null or ltrim(rtrim(p.subbatchtype)) = '''' then p.batchtype else p.subbatchtype end,
                p.uid as payment_identifier,
                p.comment as comment
            FROM
            payhistory p  with (nolock) join master m  with (nolock) on p.number = m.number
                join receiver_reference r  with (nolock) on r.receivernumber = m.number
            WHERE 
                p.batchtype in (''DA'',''DAR'') and ISNULL(aimsendingid,0) = 0 and totalpaid <> 0 and
                r.clientid = ' + cast(@clientid as varchar(10)) + '
                and datetimeentered > ' + '''' + convert(varchar(25),@lastFileSentDT,121) + ''''
		END
	END
	-- Otherwise we are using the new schema that sends more fields.
	ELSE
	BEGIN

		set @sql = '
           SELECT
           ''APAY'' as record_type,
           r.sendernumber as file_number,
           m.account as account, ' +
            --dbo.Custom_CalculatePaymentTotalPaid(p.uid)+ isnull(p.OverPaidAmt,0) as payment_amount,--
			@paymentString + 

           'p.datepaid as payment_date,
           ''payment_type'' =
           case  p.batchtype
           when ''PU'' then ''PA''
           when ''PUR'' then ''PAR''
           when ''PA'' then ''PA''
           when ''PAR'' then ''PAR''
           end,
           p.uid as payment_identifier,
           p.comment as comment,
           p.paid1 as payment_amount_bucket1,
           p.paid2 as payment_amount_bucket2,
           p.paid3 as payment_amount_bucket3,
           p.paid4 as payment_amount_bucket4,
           p.paid5 as payment_amount_bucket5,
           p.paid6 as payment_amount_bucket6,
           p.paid7 as payment_amount_bucket7,
           p.paid8 as payment_amount_bucket8,
           p.paid9 as payment_amount_bucket9,
           p.paymethod as payment_method,
           ''N'' as is_SIF,
           dbo.DetermineInvoicedAmount(p.invoiceflags,p.fee1,p.fee2,p.fee3,p.fee4,p.fee5,p.fee6,p.fee7,p.fee8,p.fee9,0) as fee_amount,
           p.fee1 as fee_amount_bucket1,
           p.fee2 as fee_amount_bucket2,
           p.fee3 as fee_amount_bucket3,
           p.fee4 as fee_amount_bucket4,
           p.fee5 as fee_amount_bucket5,
           p.fee6 as fee_amount_bucket6,
           p.fee7 as fee_amount_bucket7,
           p.fee8 as fee_amount_bucket8,
           p.fee9 as fee_amount_bucket9,
           dbo.Custom_CalculatePaymentTotalPaid(p.uid)+isnull(p.OverPaidAmt,0) - 
           dbo.DetermineInvoicedAmount(p.invoiceflags,p.fee1,p.fee2,p.fee3,p.fee4,p.fee5,p.fee6,p.fee7,p.fee8,p.fee9,0)as remit_amount,
           CAST(ISNULL(p.invoice,'''') as varchar(50)) as invoice_identifier
           FROM
               payhistory p  with (nolock) join master m  with (nolock) on p.number = m.number
                   join receiver_reference r  with (nolock) on r.receivernumber = m.number
            WHERE 
               r.clientid = ' + cast(@clientid as varchar(10)) + '
               and
               p.invoice in (' + @invoices+')
               and 
               p.batchtype not in (''PC'',''PCR'')'

		-- Are we sending adjustments?
		IF(@sendAdjustments = 1)
		BEGIN
			set @sql = @sql + '  
		    UNION
		    SELECT
                ''APAY'' as record_type,
                r.sendernumber as file_number,
                m.account as account,
                p.totalpaid as payment_amount,
                p.datepaid as payment_date,
                ''payment_type'' =
                case when p.subbatchtype is null or ltrim(rtrim(p.subbatchtype)) = '''' then p.batchtype else p.subbatchtype end,
                p.uid as payment_identifier,
                p.comment as comment,
    			p.paid1 as payment_amount_bucket1,
	    		p.paid2 as payment_amount_bucket2,
		    	p.paid3 as payment_amount_bucket3,
			    p.paid4 as payment_amount_bucket4,
			    p.paid5 as payment_amount_bucket5,
			    p.paid6 as payment_amount_bucket6,
			    p.paid7 as payment_amount_bucket7,
			    p.paid8 as payment_amount_bucket8,
			    p.paid9 as payment_amount_bucket9,
			    p.paymethod as payment_method,
			    ''N'' as is_SIF,
			    0 as fee_amount,
			    0 as fee_amount_bucket1,
			    0 as fee_amount_bucket2,
			    0 as fee_amount_bucket3,
			    0 as fee_amount_bucket4,
			    0 as fee_amount_bucket5,
			    0 as fee_amount_bucket6,
			    0 as fee_amount_bucket7,
			    0 as fee_amount_bucket8,
			    0 as fee_amount_bucket9,
			    0 as remit_amount,
			    CAST(ISNULL(p.invoice,'''') as varchar(50)) as invoice_identifier
		    FROM
			    payhistory p  with (nolock) join master m  with (nolock) on p.number = m.number
                join receiver_reference r  with (nolock) on r.receivernumber = m.number
		    WHERE 
		    p.batchtype in (''DA'',''DAR'') and ISNULL(aimsendingid,0) = 0 and totalpaid <> 0 and
		    r.clientid = ' + cast(@clientid as varchar(10)) + '
                and datetimeentered > ' + '''' + convert(varchar(25),@lastFileSentDT,121) + ''''

	END
END
	--select @sql	
	exec(@sql)
END
GO
