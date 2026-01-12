#!/bin/sh

# define any database/apex credentials necessary to deploy the database schemas and/or applications

# define DSC schema credentials
DB_DSC_USER="DSC"
DB_DSC_PASSWORD="[CONTAINER_PW]"

# define DSC connection string
DSC_CREDENTIALS="$DB_DSC_USER/$DB_DSC_PASSWORD@${DBHOST}:${DBPORT}/${DBSERVICENAME}"

# define the DSC database folder path
DSC_FOLDER_PATH="/usr/src/DSC/SQL"


# define TEMPL_PROJ schema credentials
DB_TEMPL_PROJ_USER="TEMPL_PROJ"
DB_TEMPL_PROJ_PASSWORD="[CONTAINER_PW]"

# define TEMPL_PROJ connection string
TEMPL_PROJ_CREDENTIALS="$DB_TEMPL_PROJ_USER/$DB_TEMPL_PROJ_PASSWORD@${DBHOST}:${DBPORT}/${DBSERVICENAME}"

# define TEMPL_PROJ_APP schema credentials
DB_TEMPL_APP_USER="TEMPL_PROJ_APP"
DB_TEMPL_APP_PASSWORD="[CONTAINER_PW]"

# define TEMPL_PROJ connection string
TEMPL_APP_CREDENTIALS="$DB_TEMPL_APP_USER/$DB_TEMPL_APP_PASSWORD@${DBHOST}:${DBPORT}/${DBSERVICENAME}"

# define the TEMPL_PROJ database folder path
TEMPL_PROJ_FOLDER_PATH="/usr/src/STP/SQL"
