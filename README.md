# PIAS-simulation
The simulation steps of PIAS are as follows.

Step 1: Implement PIAS in NS2.34. 
        The NS2 source code of PIAS can be found at  https://github.com/HKUST-SING/PIAS-NS2.
Step 2: To trace the start time and end time of a flow, we modified the tcp.h, tcp.cc and tcp-full.cc of PIAS. 
        Replace these files with the same name files we provided.
Step 3: go to the folder ns2.34, run the command:
        make
Step 4: run the simulation script.
        ns pias.tcl
Step 5: The completion time of short flows can be found at file trace_cmptime.tr.

