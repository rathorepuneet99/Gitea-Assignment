Gitea Build and Run Automation

Objective

Created a Bash script to automate building and running Gitea locally without Docker or manually executing each command.

Script

The automation is implemented in:

build-and-run-gitea.sh

What the Script Does

The script performs the following steps:

Detects the directory where the script is located.

Verifies that the directory is a valid Gitea project by checking for go.mod and Makefile.

Configures the required Go environment dynamically.

Creates project-relative directories for Go temporary files and build cache.

Ensures the home directory environment is available to Gitea.

Checks whether the required tools are installed:

Git

Go

Node.js

npm

pnpm

Make

Displays the installed dependency versions.

Builds Gitea from source using Make.

Verifies that gitea.exe was created successfully.

Checks whether port 3000 is already in use.

Starts the Gitea web server.

Displays the local URL: http://localhost:3000.

Running the Script

Run the following command from Git Bash:

./build-and-run-gitea.sh

The script automatically determines its own project directory using the script location. No user-specific paths such as a Windows username or fixed project directory are hard-coded.

Environment and Portability

The script uses the existing Go configuration through go env and derives the Go module cache from GOPATH.

For Go build operations, the script creates the following directories inside the project:

.go-tmp/ - temporary Go build files

.go-cache/ - Go build cache

This avoids relying on protected Windows system directories and makes the script more reliable in the Git Bash/Windows environment.

Dependency Checks

Before starting the build, the script verifies that the following commands are available in PATH:

git

go

node

npm

pnpm

make

If any required tool is missing, the script displays an error and exits immediately.

The script also displays the installed versions of each dependency.

Build Process

The script builds Gitea from source using:

make build

The build uses the following tags:

bindata sqlite sqlite_unlock_notify

If the build fails, the script stops and reports:

[ERROR] Gitea build failed.

Binary Verification

After the build completes, the script checks for:

gitea.exe

If the binary is not found, the script exits with an error instead of attempting to start Gitea.

Port Handling

Before starting the server, the script checks whether port 3000 is already in use.

If the port is occupied, the script stops and displays an error instructing the user to stop the process using the port.

This prevents the script from attempting to start another Gitea instance on an occupied port.

Starting Gitea

When all checks pass, the script starts Gitea using:

./gitea.exe web

The script displays:

Gitea is starting...
Local URL: http://localhost:3000

Gitea can then be accessed through:

http://localhost:3000

Error Handling

The script uses:

set -euo pipefail

and explicit checks for important operations.

It exits when:

The project directory is invalid.

A required dependency is unavailable.

The Gitea build fails.

The Gitea binary is missing.

Port 3000 is already in use.

netstat is unavailable for the port check.

Clear [INFO], [SUCCESS], and [ERROR] messages are used to show progress and failures.

Testing and Verification

The automation was tested in Git Bash on Windows.

The script successfully:

Detected the Gitea project directory.

Detected all required dependencies.

Displayed dependency versions.

Configured the Go environment.

Built Gitea from source.

Verified the generated gitea.exe.

Checked port 3000.

Started the Gitea web server.

Made Gitea available at http://localhost:3000.

The port-conflict handling was also tested by running the script while Gitea was already running. The script correctly detected that port 3000 was occupied and exited without starting another instance.

Docker

Docker was not used. Gitea was built from source and started directly using the generated executable.

What I Learned

This task helped me convert a manual development workflow into a repeatable Bash automation script. I learned how to validate dependencies, manage Go environment variables, handle Windows-specific build and permission issues, verify build artifacts, check port availability, and implement clear error handling.

I also learned the importance of making automation portable by avoiding hard-coded user-specific paths.

Conclusion

The build-and-run-gitea.sh script successfully automates the local Gitea build and startup workflow and provides clear status messages and error handling throughout the process.
