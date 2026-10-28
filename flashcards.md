# Server Health Monitor --- One-Page Flashcards

Cover the **Answer** column and retrieve each answer from memory.

  --------------------------------------------------------------------------------
                            \# Front --- Question    Back --- Answer
  ---------------------------- --------------------- -----------------------------
                             1 What is the project   Monitor CPU, memory, and
                               for?                  disk; report health and log
                                                     results.

                             2 Which language is     Bash shell scripting.
                               used?                 

                             3 Which command         `top`
                               provides CPU data on  
                               macOS?                

                             4 Which commands        `vm_stat`, `pagesize`, and
                               provide memory        `sysctl`.
                               information?          

                             5 Which command checks  `df`
                               disk usage?           

                             6 What are the three    `HEALTHY`, `WARNING`,
                               health states?        `CRITICAL`.

                             7 What are the          Below 70: HEALTHY; 70--89:
                               thresholds?           WARNING; 90 or above:
                                                     CRITICAL.

                             8 What do exit codes 0, 0: HEALTHY; 1:
                               1, and 2 mean?        WARNING/general error; 2:
                                                     CRITICAL.

                             9 Where are results     `logs/health.log`
                               logged?               

                            10 How do you check Bash `bash -n health_monitor.sh`
                               syntax?               

                            11 How do you view       `tail -n 7 logs/health.log`
                               recent log lines?     

                            12 How do you enable     Prefix the run with
                               test mode?            `TEST_MODE=1` and test-value
                                                     variables.

                            13 How do you read the   Run `echo $?` immediately
                               previous command's    afterward.
                               exit code?            

                            14 What does no output   No syntax error was reported.
                               from `bash -n` mean?  

                            15 What is a             It is a simplified estimate,
                               memory-metric         not complete macOS memory
                               limitation?           accounting.
  --------------------------------------------------------------------------------

## Recall Challenge

Without looking, explain: (1) how thresholds determine status, (2) why
exit codes matter in automation, (3) how the log is updated, and (4) one
improvement you would make next.
