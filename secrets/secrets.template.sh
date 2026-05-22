#--- Credentials ---

# define the default admin user for Oracle
ORACLE_ADMIN_USER="SYS"

# Set your oracle administrator password here: SYS and SYSTEM database schema passwords, APEX administrator password (workspace = INTERNAL, user = ADMIN), and the ORDS_PUBLIC_USER password
ORACLE_PWD='YOUR_PASSWORD'

# define any database/apex credentials necessary to deploy the database schemas and/or applications

# define DSC credentials
DSC_USER="DSC"
DSC_PWD='YOUR_DSC_PASSWORD'

# define STP credentials
STP_DB_USER="TEMPL_PROJ"
STP_DB_PASSWORD='YOUR_PASSWORD'

# define STPA credentials
STP_APP_DB_USER="TEMPL_PROJ_APP"
STP_APP_DB_PASSWORD='YOUR_PASSWORD'

# define the STP Apex credentials
STP_APX_USER="TEMPL_PROJ_APP_DEV"
STP_APX_PWD='YOUR_PASSWORD'