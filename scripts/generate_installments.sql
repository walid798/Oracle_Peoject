DECLARE
    CURSOR contracts_cursor IS
        SELECT * FROM HR.CONTRACTS;
    v_added_months NUMBER(2);
    v_installment_date DATE;
    v_installment_count NUMBER(2);
BEGIN
    FOR v_contracts_record IN contracts_cursor LOOP
        IF UPPER(v_contracts_record.contract_payment_type) = 'ANNUAL' THEN
            v_added_months := 12;
        ELSIF UPPER(v_contracts_record.contract_payment_type) = 'HALF_ANNUAL' THEN
            v_added_months := 6;
        ELSIF UPPER(v_contracts_record.contract_payment_type) = 'QUARTER' THEN
            v_added_months := 3;
        ELSIF UPPER(v_contracts_record.contract_payment_type) = 'MONTHLY' THEN
            v_added_months := 1;
        ELSE
            RAISE_APPLICATION_ERROR(-20005, 'Invalid contract payment type');
        END IF;

        v_installment_date := v_contracts_record.contract_startdate;
        v_installment_count := TRUNC(MONTHS_BETWEEN(v_contracts_record.contract_enddate, v_contracts_record.contract_startdate) / v_added_months);

        LOOP
            INSERT INTO HR.INSTALLMENTS_PAID (INSTALLMENT_ID, CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
            VALUES (HR.INSTALLMENTS_PAID_SEQ.NEXTVAL, v_contracts_record.contract_id, v_installment_date, 0, 0);

            v_installment_date := ADD_MONTHS(v_installment_date, v_added_months);

            IF v_installment_date >= v_contracts_record.contract_enddate THEN
                EXIT;
            END IF;
        END LOOP;

        UPDATE HR.INSTALLMENTS_PAID
        SET INSTALLMENT_AMOUNT = (v_contracts_record.contract_total_fees - NVL(v_contracts_record.contract_deposit_fees, 0)) / v_installment_count
        WHERE CONTRACT_ID = v_contracts_record.contract_id;
    END LOOP;
END;

