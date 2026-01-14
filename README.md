# PIFSC Standalone Template Project (STP) Containerized Oracle Developer Environment

## Overview
The PIFSC Standalone Template Project (STP) Containerized Oracle Developer Environment (STCODE) project was developed to provide a custom containerized Oracle development environment (CODE) for the CAS.  This repository can be forked to extend the existing functionality to any data systems that depend on the CAS for both development and testing purposes.  

## Resources
-   ### STCODE Version Control Information
    -   URL: https://github.com/noaa-pifsc/PIFSC-STP-Containerized-Oracle-Development-Environment
    -   Version: 1.0 (git tag: STP_CODE_v1.0)
    -   Upstream repository:
        -   DSC CODE (DCODE) Version Control Information:
            -   URL: https://github.com/noaa-pifsc/PIFSC-DSC-Containerized-Oracle-Development-Environment
            -   Version: 1.3 (git tag: DSC_CODE_v1.3)

## Dependencies
\* Note: all dependencies are implemented as git submodules in the [modules](./modules) folder
-   ### STP Version Control Information
    -   folder path: [modules/TP](./modules/TP) 
    -   Version Control Information:
        -   URL: <git@picgitlab.nmfs.local:centralized-data-tools/template-project.git>
        -   Database: 1.3 (Git tag: templ_proj_db_v1.3)
        -   Application: 1.3 (Git tag: templ_proj_dm_app_v1.3)
-   ### DSC Version Control Information
    -   folder path: [modules/DSC](./modules/DSC) 
    -   Version Control Information:
        -   URL: <git@picgitlab.nmfs.local:centralized-data-tools/pifsc-dsc.git>
        -   Database: 1.1 (Git tag: dsc_db_v1.1)
-   ### Container Deployment Scripts (CDS) Version Control Information
    -   folder path: [modules/CDS](./modules/CDS)
    -   Version Control Information:
        -   URL: <git@github.com:noaa-pifsc/PIFSC-Container-Deployment-Scripts.git>
        -   Scripts: 1.1 (Git tag: pifsc_container_deployment_scripts_v1.1)

## Prerequisites
-   See the CODE [Prerequisites](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file#prerequisites) for details

## Repository Fork Diagram
-   See the CODE [Repository Fork Diagram](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file#repository-fork-diagram) for details

## Runtime Scenarios
-   See the CODE [Runtime Scenarios](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file#runtime-scenarios) for details

## Automated Deployment Process
-   ### Prepare the project
    -   Recursively clone the [STCODE repository](#stcode-version-control-information) to a working directory
-   ### Build and Run the Containers 
    -   See the CODE [Build and Run the Containers](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file#build-and-run-the-containers) for details
    -   #### DSC Database Deployment
        -   [create_docker_schemas.sql](https://picgitlab.nmfs.local/centralized-data-tools/pifsc-dsc/-/blob/main/SQL/dev_container_setup/create_docker_schemas.sql?ref_type=heads) is executed by the SYS schema to create the DSC schema and grant the necessary privileges
        -   [deploy_dev_container.sql](https://picgitlab.nmfs.local/centralized-data-tools/pifsc-dsc/-/blob/main/SQL/automated_deployments/deploy_dev_container.sql?ref_type=heads) is executed with the DSC schema to deploy the objects to the DSC schema
    -   #### STP Database Deployment
        -   [create_docker_schemas.sql](https://picgitlab.nmfs.local/centralized-data-tools/template-project/-/blob/master/STP/SQL/dev_container_setup/create_docker_schemas.sql?ref_type=heads) is executed to create the STP schemas, roles, and APEX workspace
        -   [deploy_dev_container.sql](https://picgitlab.nmfs.local/centralized-data-tools/template-project/-/blob/master/STP/SQL/automated_deployments/deploy_dev_container.sql?ref_type=heads) is executed with the TEMPL_PROJ schema to deploy the objects to the TEMPL_PROJ schema
        -   [deploy_apex_dev.sql](https://picgitlab.nmfs.local/centralized-data-tools/template-project/-/blob/master/STP/SQL/automated_deployments/deploy_apex_dev.sql?ref_type=heads) is executed with the TEMPL_PROJ_APP schema to deploy the objects to the TEMPL_PROJ_APP schema and the app to the TEMPL_PROJ_APP APEX workspace

## Customization Process
-   ### Implementation
    -   \*Note: this process will fork the STCODE parent repository and repurpose it as a project-specific CODE
    -   Fork [this repository](#stcode-version-control-information)
    -   See the CODE [Implementation](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file#implementation) for details 
-   ### Upstream Updates
    -   See the CODE [Upstream Updates](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file#upstream-updates) for details

## Container Architecture
-   See the CODE [container architecture documentation](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file/-/blob/main/README.md?ref_type=heads#container-architecture) for details
-   ### STCODE Customizations:
    -   [docker/.env](./docker/.env) was updated to define an appropriate APP_SCHEMA_NAME valu and to specify an TARGET_APEX_VERSION to re-enable Apex
    -   [custom_deployment_functions.sh](./deployment_scripts/functions/custom_deployment_functions.sh) was updated to add the [CODE-ords.yml](./docker/CODE-ords.yml) configuration file to enable the ords container
    -   [custom-docker-compose.yml](./docker/custom-docker-compose.yml) was updated to define CODE-specific mounted volume overrides for the database and application deployments
    -   [custom_db_app_deploy.sh](./docker/src/deployment_scripts/custom_db_app_deploy.sh) was updated to deploy the STP database schemas and the Apex app
    -   [custom_container_config.sh](./docker/src/deployment_scripts/config/custom_container_config.sh) was updated to define DB credentials and mounted volume file paths for the CAS SQL scripts

## Connection Information
-   See the CODE [connection information documentation](https://github.com/noaa-pifsc/PIFSC-Containerized-Oracle-Development-Environment?tab=readme-ov-file/-/blob/main/README.md?ref_type=heads#connection-information) for details
-   ### DSC Database Connection Information
    -   Connection information can be found in [create_docker_schemas.sql](https://picgitlab.nmfs.local/centralized-data-tools/pifsc-dsc/-/blob/main/SQL/dev_container_setup/create_docker_schemas.sql?ref_type=heads)
-   ### STP Database Connection Information
    -   Connection information can be found in [create_docker_schemas.sql](https://picgitlab.nmfs.local/centralized-data-tools/template-project/-/blob/master/STP/SQL/dev_container_setup/create_docker_schemas.sql?ref_type=heads)

## License
See the [LICENSE.md](./LICENSE.md) for details

## Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.