# Tomcat automation workspace

This workspace contains standalone shell scripts for installing Apache Tomcat on Linux hosts.

## Files
- `tomcat_rpm.sh` for RPM-based systems
- `tomcat_ubuntu.sh` for Ubuntu/Debian systems
- `tomcat_setup.sh` to auto-detect and run the appropriate installer
- `push_tomcat_setup.sh` to deploy the scripts to hosts listed in `tomcat_hosts.txt`

## Usage
```bash
chmod +x tomcat_setup.sh tomcat_rpm.sh tomcat_ubuntu.sh push_tomcat_setup.sh
./push_tomcat_setup.sh
```
