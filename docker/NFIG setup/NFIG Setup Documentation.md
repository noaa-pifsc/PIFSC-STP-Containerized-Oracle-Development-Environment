# NFIG Setup Documentation

## Overview
This document provides information about how to setup the NOAA Federated Identity Gateway (NFIG) from scratch on a new apex application or use the Standalone Template Project (STP) Application (Containerized Oracle Development Environment (CODE). 

## Requirements
-   This documentation was developed using Apex version 23.2

## Resources

## Procedure
-   ### Server Setup



-   ### Apex Implementation
    -   ### New/Existing Apex Application
        -   Define the workspace credentials (for NFIG), by executing the following code using a schema that has permissions on the desired workspace (e.g. parsing schema):
            -   \*Note these credentials can be used across multiple apps within the workspace
            -   ```
                BEGIN
                    -- Replace [CLIENT_ID] with the NFIG Client ID and replace [CLIENT_SECRET] with the NFIG Client Secret before executing the PL/SQL code
                    APEX_CREDENTIAL.CREATE_CREDENTIAL(
                        p_credential_name => 'NFIG_prod',
                        p_credential_static_id => 'NFIG_PROD',
                        p_authentication_type=> APEX_CREDENTIAL.C_TYPE_OAUTH_CLIENT_CRED,
                        p_client_id            => '[CLIENT_ID]',
                        p_client_secret        => '[CLIENT_SECRET]',
                        p_credential_comment => 'Apex web credentials for NOAA Federated Identity Gateway (NFIG)'
                    );
                    COMMIT;
                END;
                /
                ```
        -   Login to the workspace for the new/existing application's 
        -   Create a new Application Item ("Shared Components"->"Application Items"->"Create >") with the following values:
            -   Name: APP_EMAIL
            -   Scope: Application
            -   \*Note: The APP_EMAIL application item will be set to the authenticated user's email address following a successfuly NFIG login
        -   <mark> define the post_oauth_sp procedure
        -   <mark> create the new authentication scheme with the following values:
        -   <mark> create an authorization scheme that utilizes the APP_EMAIL application item (use v('APP_EMAIL') to use it in queries/procedures)





    -   ### STP CODE Application
        -   Clone the STP CODE project into a working directory
            -   Switch the branch to "Branch_NFIG_implement"
            -   Build and run the container using the [STP CODE automated deployment process](#automated-deployment-process) 
        -   Import the application definition file into the TEMPL_PROJ_APP workspace: [f278_nfig_version.sql](./f278_nfig_version.sql)
        -   Update the existing workspace credentials (for NFIG), by executing the folllowing using a schema that has permissions on the desired workspace (e.g. parsing schema):
            -   \*Note: these credentials are not saved within the application definition file, so they need to be redefined.
            -   ```
                BEGIN
                    -- Update the secrets for the existing credential definition (NFIG_PROD)
                    -- Replace [CLIENT_ID] with the NFIG Client ID and replace [CLIENT_SECRET] with the NFIG Client Secret before executing the PL/SQL code
                    APEX_CREDENTIAL.SET_PERSISTENT_CREDENTIALS(
                        p_credential_static_id => 'NFIG_PROD',
                        p_client_id            => '[CLIENT_ID]',
                        p_client_secret        => '[CLIENT_SECRET]'
                    );
                    COMMIT;
                END;
                /
                ```
        -   Execute the []() script as the data schema (if one is defined, otherwise use the parsing schema):
            -   <mark> run the auth_app_pkg upgrade script
            -   <mark> run the auth_app_pkg grant script
    
        -   Execute the following SQL commands as the parsing schema (if a data schema exists):
            -   <mark> run the synonym creation script
