import subprocess
import sys
import ssl
proxy = ""
packages = "python-ldap"
pip_cmd = "install"
for package in packages.split(","):
  subprocess.check_call([sys.executable, "-m", "pip", "--proxy", proxy, pip_cmd, package])
