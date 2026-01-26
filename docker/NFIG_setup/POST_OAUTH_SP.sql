create or replace 
--custom post oauth stored procedure to process successful oath logins
procedure POST_OAUTH_SP IS

    v_error_msg  VARCHAR2(4000); 
    v_uuid       VARCHAR2(200);

	oauth_uuid_null EXCEPTION;
	oauth_email_null EXCEPTION;
	oauth_email_verified_null EXCEPTION;

BEGIN

	--set the APP_USER value to the email since that is used to uniquely identify the user
	APEX_CUSTOM_AUTH.SET_USER(apex_json.get_varchar2('email'));

    -- validate the return values from oauth
    IF apex_json.get_varchar2('sub') IS NULL THEN
        RAISE oauth_uuid_null;
    ELSIF apex_json.get_varchar2('email') IS NULL THEN
		RAISE oauth_email_null;
    ELSIF apex_json.get_varchar2('email_verified') IS NULL THEN
		RAISE oauth_email_verified_null;
	ELSE
		--there are no null values in the sub, email, or email_verified oauth response fields

		--save the email_verified in APP_EMAIL_VERIFIED variable
		apex_session_state.set_value('APP_EMAIL_VERIFIED', apex_json.get_varchar2('email_verified'));

		--save the email_verified in APP_UUID variable
		apex_session_state.set_value('APP_UUID', apex_json.get_varchar2('sub'));

	END IF;

EXCEPTION
	WHEN oauth_uuid_null THEN
		DBMS_OUTPUT.PUT_LINE('Oauth returned a unique user id (sub) value of null');
		
		--raise a custom application error:
		RAISE_APPLICATION_ERROR (-20000, 'Oauth returned a unique user id (sub) value of null');
	WHEN oauth_email_null THEN
		DBMS_OUTPUT.PUT_LINE('Oauth returned an email value of null');
		
		--raise a custom application error:
		RAISE_APPLICATION_ERROR (-20001, 'Oauth returned an email value of null');
	WHEN oauth_email_verified_null THEN
	
		DBMS_OUTPUT.PUT_LINE('Oauth returned an email_verified value of null');
		
		--raise a custom application error:
		RAISE_APPLICATION_ERROR (-20002, 'Oauth returned an email_verified value of null');

    WHEN OTHERS THEN
        v_error_msg := SQLERRM; 

		DBMS_OUTPUT.PUT_LINE('Processing Error: ' || v_error_msg);
        RAISE; 

end POST_OAUTH_SP;
/




