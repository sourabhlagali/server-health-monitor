# Server Health Monitor

A Bash-based macOS system monitoring tool that checks CPU, memory, and
disk usage, classifies health, displays the top five CPU-consuming
processes, and logs timestamped results.

## Features

-   CPU utilization using `top`.
-   Estimated memory usage using `vm_stat`, `pagesize`, and `sysctl`.
-   Root filesystem disk usage using `df`.
-   Top five CPU-consuming processes using `ps`.
-   `HEALTHY`, `WARNING`, and `CRITICAL` status classification.
-   Overall health status and timestamped logging to `logs/health.log`.
-   Basic command-output validation and exit codes.
-   Test mode for checking status and exit-code logic.

## Technology

Bash, macOS command-line tools (`top`, `vm_stat`, `pagesize`, `sysctl`,
`df`, `ps`, `awk`), Git, and GitHub.

## Project Structure

``` text
server-health-monitor/
├── health_monitor.sh
├── README.md
├── .gitignore
└── logs/
    └── health.log
```

## Requirements and Limitations

-   macOS, Bash, and standard macOS command-line utilities.
-   This script uses macOS-specific commands and is not guaranteed to
    work unchanged on Linux.
-   Memory usage is a simplified estimate from selected statistics, not
    complete macOS memory accounting.
-   The thresholds below are project-defined values, not universal
    operating-system standards.

## Run the Project

From the project directory:

``` bash
chmod +x health_monitor.sh
./health_monitor.sh
```

To run without executable permission:

``` bash
bash health_monitor.sh
```

View recent logs:

``` bash
tail -n 7 logs/health.log
```

## Health Thresholds

  Metric value       Status
  ------------------ ------------
  Below 70%          `HEALTHY`
  70% to below 90%   `WARNING`
  90% or above       `CRITICAL`

## Exit Codes

  -----------------------------------------------------------------------
                                 Exit code Meaning
  ---------------------------------------- ------------------------------
                                       `0` Overall status is `HEALTHY`

                                       `1` Overall status is `WARNING`,
                                           or a general script error
                                           exits with code 1

                                       `2` Overall status is `CRITICAL`
  -----------------------------------------------------------------------

Exit codes allow other scripts and automation tools to interpret a
monitoring run.

## Test Status and Exit Codes

Run each command from the project directory. Run `echo $?` immediately
after each command to read its exit code.

**Healthy test**

``` bash
TEST_MODE=1 TEST_CPU=50 TEST_MEMORY=50 TEST_DISK=50 ./health_monitor.sh
echo $?
```

Expected: `Overall Status: HEALTHY`; exit code `0`.

**Warning test**

``` bash
TEST_MODE=1 TEST_CPU=75 TEST_MEMORY=50 TEST_DISK=50 ./health_monitor.sh
echo $?
```

Expected: `Overall Status: WARNING`; exit code `1`.

**Critical test**

``` bash
TEST_MODE=1 TEST_CPU=95 TEST_MEMORY=50 TEST_DISK=50 ./health_monitor.sh
echo $?
```

Expected: `Overall Status: CRITICAL`; exit code `2`.

All three scenarios were executed successfully. **Test-mode
limitation:** the current script may print live CPU, memory, and disk
figures while using injected test values to calculate statuses and exit
codes. During test mode, the status and exit code are simulated; the
displayed metric figures may not be the injected values.

## Validate Bash Syntax

``` bash
bash -n health_monitor.sh
```

No output indicates Bash reported no syntax error.

## Learning Outcomes

-   Bash variables, functions, conditionals, arithmetic, and command
    substitution.
-   Pipelines and parsing command output with `awk`.
-   Numeric validation and error handling.
-   System metrics, timestamps, log files, and exit codes.
-   Testing healthy, warning, and critical paths.
-   Preparing a project for Git and GitHub.

## Possible Improvements

-   Display injected test metrics clearly in test mode.
-   Add configurable thresholds and notifications.
-   Schedule checks with macOS `launchd`.
-   Add unit tests and improve portability.

## Author

Sourabh Lagali
