-- -------------------------------------------------------------------------
-- Script: configure_apex_AWS_cognito.sql
-- Purpose: Configure Network ACLs and APEX Wallet Settings
-- Run as: SYSDBA
-- -------------------------------------------------------------------------

ALTER SESSION SET CONTAINER = FREEPDB1;

PROMPT Configuring Network ACL for AWS Cognito...

set serveroutput on;

DECLARE
    v_apex_schema VARCHAR2(128);
BEGIN

    DBMS_OUTPUT.PUT_LINE('starting PL/SQL block');


    -- Dynamically find the installed APEX schema (e.g., APEX_230100 or APEX_240100)
    -- This prevents errors if the APEX version changes in the container image
    SELECT schema 
      INTO v_apex_schema 
      FROM dba_registry WHERE comp_id = 'APEX';

    DBMS_OUTPUT.PUT_LINE('Detected APEX Schema: ' || v_apex_schema);

    -- Create the ACL
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('connect', 'resolve'),
            principal_name => v_apex_schema,
            principal_type => XS_ACL.PTYPE_DB
        )
    );
END;
/

PROMPT Configuring APEX Instance Wallet...

BEGIN
    -- Set the Wallet Path in APEX Instance Settings
    APEX_INSTANCE_ADMIN.SET_PARAMETER('WALLET_PATH', 'file:/opt/oracle/wallet');
    COMMIT;
END;
/

PROMPT Configuration Complete.

DISCONNECT
EXIT