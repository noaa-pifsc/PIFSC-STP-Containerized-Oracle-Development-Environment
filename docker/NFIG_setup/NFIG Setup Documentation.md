# NFIG Setup Documentation

## Overview
This document provides information about how to setup the NOAA Federated Identity Gateway (NFIG) from scratch on a new apex application or use the Standalone Template Project (STP) Application (Containerized Oracle Development Environment (CODE). 

## Requirements
-   This documentation was developed using Apex version 23.2

## Resources

## Procedure
-   ### Apex Implementation
    -   ### New/Existing Apex Application
        -   #### Server Setup
            -   create/setup Oracle Wallet 
                -   [setup_wallet.sh](./setup_wallet.sh) was executed with the root account on the oracle database to create the Oracle wallet, download the AWS certificate, and add it to the wallet.  This was intended for a new Oracle wallet setup on a blank container database
            -   configure Apex for AWS Cognito endpoint
                -   [configure_apex_AWS_cognito.sql](./configure_apex_AWS_cognito.sql) was executed with the SYSDBA account to create and configure an ACL for the Apex installation for AWS Cognito using the Oracle wallet that was created.
        -   \*Note: If the Apex application is not using a separate parsing schema for the application that access objects in an external data schema then use the data schema each time the "parsing schema" is mentioned in the instructions below: 
        -   Define the workspace credentials (for NFIG), by executing the following code using a schema that has permissions on the desired workspace (parsing schema):
            -   \*Note these credentials can be used across multiple apps within the workspace
            -   ```
                DECLARE 
	                v_workspace_id NUMBER;
                    v_workspace_name VARCHAR2(200) := '[WORKSPACE_NAME]';   -- replace [WORKSPACE_NAME] with the actual workspace name for the applications
                    v_client_id VARCHAR2(200) := '[CLIENT_ID]';    -- replace [CLIENT_ID] with the NFIG Client ID 
                    v_client_secret VARCHAR2(200) := '[CLIENT_SECRET]'; -- replace [CLIENT_SECRET] with the NFIG Client Secret
                BEGIN
	                -- get the Workspace ID for the specified workspace 
                    v_workspace_id := apex_util.find_security_group_id(p_workspace => v_workspace_name);

                    -- set the Security Group ID
                    apex_util.set_security_group_id(p_security_group_id => v_workspace_id);
	
                    -- Create the credential for the corresponding workspace's applications
                    APEX_CREDENTIAL.CREATE_CREDENTIAL(
                        p_credential_name => 'NFIG_oauth',
                        p_credential_static_id => 'NFIG_OAUTH',
                        p_authentication_type=> APEX_CREDENTIAL.C_TYPE_OAUTH_CLIENT_CRED,
                        p_credential_comment => 'Apex web credentials for NOAA Federated Identity Gateway (NFIG)'
                    );

                    --set the client ID and client secret values for the credentials
                    APEX_CREDENTIAL.SET_PERSISTENT_CREDENTIALS(
                        p_credential_static_id => 'NFIG_OAUTH',
                        p_client_id            => v_client_id,
                        p_client_secret        => v_client_secret
                    );
                    COMMIT;
                END;
                /
                ```
        -   Login to the workspace for the new/existing application 
        -   Create a new Application Item ("Shared Components"->"Application Items"->"Create >") with the following values:
            -   APP_EMAIL_VERIFIED:
                -   Name: APP_EMAIL_VERIFIED
                -   Scope: Application
                -   \*Note: The APP_EMAIL_VERIFIED application item will be set to the value of "email_verified" following a successfuly NFIG login
            -   APP_UUID:
                -   Name: APP_UUID
                -   Scope: Application
                -   \*Note: The APP_UUID application item will be set to the value of "sub" following a successfuly NFIG login
        -   define the post_oauth_sp procedure by executing the [POST_OAUTH_SP.sql](./POST_OAUTH_SP.sql) script in the data schema (if a separate parsing schema is used) 
            -   If a separate parsing schema is used, grant the parsing schema EXECUTE access to POST_AUTH_SP by executing the following command with the data schema (replace [PARSING_SCHEMA] with the parsing schema name):
                -   `GRANT EXECUTE ON POST_OAUTH_SP to [PARSING_SCHEMA];`
            -   If a separate parsing schema is used, create the synonym in the parsing schema for the POST_AUTH_SP procedure by executing the following command with the parsing schema  (replace [DATA_SCHEMA] with the data schema name):
                -   `CREATE SYNONYM POST_OAUTH_SP FOR [DATA_SCHEMA].POST_OAUTH_SP;`
        -   Create the new authentication scheme with the following values (replace [COGNITO_DOMAIN] with the cognito domain provided by the AWS Cognito Administrator):
            -   Scheme Type: Social Sign-In
            -   Credential Store: NFIG_oauth
            -   Authentication Provider: Generic OAuth2 Provider
            -   Authorization Endpoint URL: https://[COGNITO_DOMAIN]/oauth2/authorize
            -   Token Endpoint URL: https://[COGNITO_DOMAIN]/oauth2/token
            -   User Info Endpoint URL: https://[COGNITO_DOMAIN]/oauth2/userInfo
            -   Token Authentication Method: Basic Authentication and Client ID in Body
            -   Scope: email,openid
            -   Username: #sub# (#APEX_AUTH_NAME#)
            -   Additional User Attributes: email:APP_USER
            -   (Login Processing) Post-Authentication Procedure Name: POST_OAUTH_SP
            -   (Post-Logout URL) URL: https://[COGNITO_DOMAIN]/logout?client_id=[CLIENT_ID]&logout_uri=[LOGOUT_URL]
                -   \*Note: Replace [CLIENT_ID] with the Client ID value provided by AWS Cognito administrator.  Replace [LOGOUT_URL] with the logout URL provided during AWS Cognito registration (e.g. http://localhost:8181/ords/f?p=278)
        -   Save the new authentication scheme and make it the current scheme
        -   Update Apex to create/update an authorization scheme that utilizes the :APP_USER variable as the logged in user's email address value in queries/procedures
    -   ### STP CODE Application
        -   Clone the STP CODE project into a working directory
            -   Switch the branch to "Branch_NFIG_implement" and recursively update the git submodules
            -   Build and run the container using the [STP CODE automated deployment process](../../README.md#automated-deployment-process) 
            -   Configure authorized users:
                -   Connect to the container database's TEMPL_PROJ schema
                    -   Add the new user record:
                        - Add a record into the AUTH_APP_USERS table with the corresponding login email in the AUTH_APP_USERS.APP_USER_NAME field
                            -   Set the value of APP_USER_ACTIVE_YN = 'Y' 
                    -   Add the new user role record:
                        -   Add a record into the AUTH_APP_USER_GROUPS table with the corresponding APP_USER_ID from the new AUTH_APP_USERS record.  
                            -   Set the value of APP_GROUP_ID to the corresponding AUTH_APP_GROUPS record's value you want to grant to the new user
                    -   Commit the changes to the database
        -   Update the existing workspace credentials (for NFIG), by executing the folllowing using a schema that has permissions on the desired workspace (e.g. parsing schema):
            -   \*Note: these credentials are not saved within the application definition file, so they need to be redefined.
            -   ```
                DECLARE 
	                v_workspace_id NUMBER;
                    v_workspace_name VARCHAR2(200) := '[WORKSPACE_NAME]';   -- replace [WORKSPACE_NAME] with the actual workspace name for the applications
                    v_client_id VARCHAR2(200) := '[CLIENT_ID]';    -- replace [CLIENT_ID] with the NFIG Client ID 
                    v_client_secret VARCHAR2(200) := '[CLIENT_SECRET]'; -- replace [CLIENT_SECRET] with the NFIG Client Secret
                BEGIN
	                -- get the Workspace ID for the specified workspace 
                    v_workspace_id := apex_util.find_security_group_id(p_workspace => v_workspace_name);

                    -- set the Security Group ID
                    apex_util.set_security_group_id(p_security_group_id => v_workspace_id);
	
                    -- Create the credential for the corresponding workspace's applications
                    APEX_CREDENTIAL.CREATE_CREDENTIAL(
                        p_credential_name => 'NFIG_oauth',
                        p_credential_static_id => 'NFIG_OAUTH',
                        p_authentication_type=> APEX_CREDENTIAL.C_TYPE_OAUTH_CLIENT_CRED,
                        p_credential_comment => 'Apex web credentials for NOAA Federated Identity Gateway (NFIG)'
                    );

                    --set the client ID and client secret values for the credentials
                    APEX_CREDENTIAL.SET_PERSISTENT_CREDENTIALS(
                        p_credential_static_id => 'NFIG_OAUTH',
                        p_client_id            => v_client_id,
                        p_client_secret        => v_client_secret
                    );
                    COMMIT;
                END;
                /
                ```