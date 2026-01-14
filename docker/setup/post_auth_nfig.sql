-- create procedure for post authentication (define as TEMPL_PROJ)
CREATE OR REPLACE PROCEDURE post_auth_nfig IS
    v_email      VARCHAR2(200);
    v_user_role  VARCHAR2(20);
BEGIN
    -- 1. Get the username (Email) provided by Cognito
    -- APEX automatically sets APP_USER to the email because we mapped it in the Auth Scheme
    v_email := v('APP_USER');

    -- 2. Sync with local table
    MERGE INTO auth_app_users dest
    USING (SELECT v_email as email FROM dual) src
    ON (dest.app_user_name||'@noaa.gov' = src.email)
    WHEN MATCHED THEN
        UPDATE SET last_mod_date = SYSTIMESTAMP
    WHEN NOT MATCHED THEN
        INSERT (app_user_name, create_date)
        VALUES (src.email, SYSTIMESTAMP);

    -- 3. (Optional) Authorization Logic
    -- You can check if the user is allowed to log in here.
    -- IF v_email NOT LIKE '%@mycompany.com' THEN
    --     raise_application_error(-20001, 'Unauthorized domain.');
    -- END IF;

END;
/


--grant the app schema privileges on post authentication procedure (define as TEMPL_PROJ) 
GRANT EXECUTE ON post_auth_nfig to TEMPL_PROJ_APP;

--create synonym for the post authentication procedure (define as TEMPL_PROJ_APP)
CREATE SYNONYM post_auth_nfig FOR TEMPL_PROJ.post_auth_nfig;
