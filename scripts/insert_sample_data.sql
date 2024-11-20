INSERT INTO HR.CLIENTS (client_id, client_name, mobile, address, nid)
VALUES (1, 'Ahmed Omar', '0124798987', 'Cairo', NULL);

INSERT INTO HR.CONTRACTS (contract_id, contract_startdate, contract_enddate, contract_total_fees, contract_deposit_fees, client_id, contract_payment_type, notes)
VALUES (101, TO_DATE('01/01/2021', 'MM/DD/YYYY'), TO_DATE('01/01/2023', 'MM/DD/YYYY'), 500000, NULL, 1, 'ANNUAL', NULL);

COMMIT;
