create or replace PROCEDURE post_auth_nfig IS
    v_error_msg  VARCHAR2(4000); 
    v_uuid       VARCHAR2(200);

BEGIN
    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'Starting post_auth_nfig...');

    -- Get Attributes from Application Items
    v_uuid       := v('APP_USER');       -- Mapped from 'sub'

    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'apex_json.getvarchar2(email) is: ' || apex_json.get_varchar2('email'));
    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'apex_json.getvarchar2(email_verified) is: ' || apex_json.get_varchar2('email_verified'));
    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'apex_json.getvarchar2(sub) is: ' || apex_json.get_varchar2('sub'));


    -- set the APP_EMAIL application item to the email address so it can be used to verify the user's authorization
    apex_session_state.set_value('APP_EMAIL', apex_json.get_varchar2('email'));

    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'apex_json.getvarchar2(identities[1].providerName) is: ' || apex_json.get_varchar2('identities[1].providerName'));
    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'apex_json.getvarchar2(identities[1].providerType) is: ' || apex_json.get_varchar2('identities[1].providerType'));
    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'apex_json.getvarchar2(identities[1].dateCreated) is: ' || apex_json.get_varchar2('identities[1].dateCreated'));

    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'v(APP_EMAIL) is: ' || v('APP_EMAIL'));

    -- Safety Check
    IF v_uuid IS NULL THEN
        DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'post_auth_nfig', 'ABORTING: UUID is NULL');
        RETURN;
    END IF;

    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'Sync Success for: ' || v('APP_EMAIL'));

EXCEPTION
    WHEN OTHERS THEN
        v_error_msg := SQLERRM; 
        
	
		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'post_auth_nfig', 'CRITICAL ERROR: ' || v_error_msg);
        COMMIT;
        RAISE; 
END;
/


grant execute on post_auth_nfig to templ_proj_app;


create synonym post_auth_nfig for templ_proj.post_auth_nfig;



