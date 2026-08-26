# Gitea Local Setup

## Project Overview

Gitea is an open-source, self-hosted Git service written primarily in Go. It provides Git repository hosting along with features such as code review, issue tracking, project management, and other software development capabilities.

## Environment

* Operating System: Windows
* Go: 1.27.0
* Node.js: Installed
* npm: Installed
* pnpm: Installed
* GNU Make: 4.4.1
* Docker: Not used

## Repository Structure

The main directories and files I explored include:

* `cmd/` - Application commands
* `models/` - Data and database models
* `modules/` - Internal reusable modules
* `routers/` - HTTP routing and request handling
* `services/` - Application services
* `templates/` - Server-side templates
* `web_src/` - Frontend source code
* `tests/` - Automated tests
* `docs/` - Project documentation
* `main.go` - Main application entry point
* `go.mod` - Go module and dependency configuration
* `Makefile` - Build automation

## Setup Process

1. Cloned the Gitea repository to my local system.
2. Installed the required Go, Node.js, pnpm, and Make dependencies.
3. Verified the Go environment and module configuration.
4. Downloaded the project dependencies using `go mod download`.
5. Verified the downloaded modules using `go mod verify`.
6. Built Gitea from source using Make.
7. Started the generated Gitea executable without Docker.
8. Configured SQLite as the local database.
9. Verified the application through `http://localhost:3000/`.
10. Created a repository on the local Gitea instance.
11. Pushed the project to the local Gitea repository.

## Issues Encountered

During the setup, I initially faced issues related to the Go module cache and Make availability in the Windows environment.

I verified the Go environment, configured the required paths, and ensured that the required module cache was available.

I also encountered an initial MySQL authentication error while configuring Gitea. Since MySQL was not required for this local setup, I configured Gitea to use SQLite instead.

After resolving these issues, the project dependencies were successfully downloaded and verified, and Gitea was successfully built and started.

## Running Gitea

Gitea was started locally without Docker using:

```powershell
.\gitea.exe web
```

The application was successfully accessible at:

```text
http://localhost:3000/
```

## What I Learned

This assignment provided practical experience with a large open-source Go project. I learned how the Gitea repository is structured, how Go modules manage project dependencies, how Make is used for build automation, and how to troubleshoot development environment issues on Windows.

I also learned how to configure a self-hosted Git service, run it locally without Docker, configure a database, and create and manage repositories on a local Gitea instance.
