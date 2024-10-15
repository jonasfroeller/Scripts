import subprocess
import os

# This script will create a file called commits.md in your projects docs including the commits of the git project.

if not os.path.exists('./docs'):
    os.makedirs('./docs')

command = ['git', 'log', '--pretty=format:%s']

output = subprocess.check_output(command)

with open('./docs/commits.md', 'w') as file:
    file.write("# Commits\n\n")
    file.write(output.decode('utf-8'))
