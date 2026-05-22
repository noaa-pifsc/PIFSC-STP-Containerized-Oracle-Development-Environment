#!/bin/bash

	# define the database scripts mapping using the pipe character as a delimiter
	# The elements should contain encoded values with the "|" character as the delimiter: sql path (within container)|sql script file|User Secret Name|Password Secret Name|Script Password Secrets (this can be one or more optional pipe-delimited secret names when a password is injected into the script - examples include a CREATE USER command) 
	
	# create the schemas, workspace, and apex developer account
	DB_SCRIPTS_MAP+=("${BUILD_PATH}/../../projects/STP/modules/STP/STP/SQL|@dev_container_setup/create_docker_schemas.sql|oracle_admin_user|oracle_pwd|stp_db_password|stp_app_db_password|stp_apx_username|stp_apx_password")

	# create TEMPL_PROJ schema objects
	DB_SCRIPTS_MAP+=("${BUILD_PATH}/../../projects/STP/modules/STP/STP/SQL|@automated_deployments/deploy_dev_container.sql|stp_db_username|stp_db_password")

	# create TEMPL_PROJ_APP schema objects
	DB_SCRIPTS_MAP+=("${BUILD_PATH}/../../projects/STP/modules/STP/STP/SQL|@automated_deployments/deploy_apex_dev.sql|stp_app_db_username|stp_app_db_password")

	# define the array of compose files that are used by the individual projects (specify the path relative to the core/build directory
	COMPOSE_FILES+=("../../projects/STP/build/stp_secrets.yml")
	
	# add the secrets
	SECRET_MAPPING_ARR+=(
		["stp_db_username"]="STP_DB_USER"
		["stp_db_password"]="STP_DB_PASSWORD"
		["stp_app_db_username"]="STP_APP_DB_USER"
		["stp_app_db_password"]="STP_APP_DB_PASSWORD"
		["stp_apx_username"]="STP_APX_USER"
		["stp_apx_password"]="STP_APX_PWD"
	)
	
	