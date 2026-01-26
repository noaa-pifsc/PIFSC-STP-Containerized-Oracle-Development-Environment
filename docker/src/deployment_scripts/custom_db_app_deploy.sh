#!/bin/sh

echo "running the custom database and/or application deployment scripts"

# setup ACL for AWS Cognito
	echo "setup ACL for AWS Cognito"
	
	# run the AWS cognito setup script
sqlplus -s /nolog <<EOF
CONNECT $SYS_CREDENTIALS
@/usr/src/configure_apex_AWS_cognito.sql
DISCONNECT
EXIT
EOF

# run each of the sqlplus scripts to deploy the schemas, objects for each schema, applications, etc.
	echo "Create the DSC schemas"
	
	# change the directory to the DSC folder path so the SQL scripts can run without alterations
	cd ${DSC_FOLDER_PATH}

	# create the DSC schema(s)
sqlplus -s /nolog <<EOF
@dev_container_setup/create_docker_schemas.sql
$SYS_CREDENTIALS
EOF


	echo "Create the DSC objects"

	# change the directory to the DSC SQL folder to allow the scripts to run unaltered:
sqlplus -s /nolog <<EOF
@automated_deployments/deploy_dev_container.sql
$DSC_CREDENTIALS
EOF

	echo "the DSC objects were created"


	echo "SQL scripts executed successfully!"



	echo "Create the TEMPL_PROJ/TEMPL_PROJ_APP schemas"


	# change the directory to the TEMPL_PROJ folder path so the SQL scripts can run without alterations
	cd ${TEMPL_PROJ_FOLDER_PATH}

# create the TEMPL_PROJ schema(s)
sqlplus -s /nolog <<EOF
@dev_container_setup/create_docker_schemas.sql
$SYS_CREDENTIALS
EOF



	echo "Create the TEMP_PROJ objects"

# run the container database deployment script
sqlplus -s /nolog <<EOF
@automated_deployments/deploy_dev_container.sql
$TEMPL_PROJ_CREDENTIALS
EOF

	echo "The TEMP_PROJ objects were created"


	echo "Create the TEMPL_PROJ_APP objects"

# run the container APEX app deployment script
sqlplus -s /nolog <<EOF
@automated_deployments/deploy_apex_dev.sql
$TEMPL_APP_CREDENTIALS
EOF

	echo "The TEMPL_PROJ_APP objects were created"

echo "custom deployment scripts have completed successfully"
