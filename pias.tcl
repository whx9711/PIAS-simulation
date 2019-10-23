set mean_link_delay 0.0000002
#set host_delay 0.000020
set queueSize 240
#load=0.9 is adopted because background flows are used in simulations. 
set load  0.9
#set load  [0.9,0.8,0.7,0.6,0.5]
set connections_per_pair 1


#### Multipath
set enableMultiPath 1
set perflowMP 0

#### Transport settings options
set sourceAlg DCTCP-Sack  ;# Sack or DCTCP-Sack
set initWindow 70
set ackRatio 1
set slowstartrestart true
set DCTCP_g 0.0625  ;# DCTCP alpha estimation gain
set min_rto 0.0002
set prob_cap_ 5 ; # Threshold of consecutive timeouts to trigger probe mode

#### Switch side options
set switchAlg Priority ; # DropTail (pFabric), RED (DCTCP) or Priority (PIAS)
#set switchAlg DropTail ; # DropTail (pFabric), RED (DCTCP) or Priority (PIAS)
set DCTCP_K 65.0
set drop_prio_ true
set prio_scheme_ 2
set deque_prio_ true
set keep_order_  true
set prio_num_ 8
set ECN_scheme_ 2 ;#Per-port ECN marking
#threshold is set according to load=0.9
#set pias_thresh_0  1108140 ; # 759*1460


#set pias_thresh_0 = [759*1460, 909*1460, 999*1460, 956*1460, 1059*1460]
#set pias_thresh_1 = [1132*1460, 1329*1460, 1305*1460, 1381*1460, 1412*1460]
#set pias_thresh_2 = [1456*1460, 1648*1460, 1564*1460, 1718*1460, 1643*1460]
#set pias_thresh_3 = [1737*1460, 1960*1460, 1763*1460, 2028*1460, 1869*1460]
#set pias_thresh_4 = [2010*1460, 2143*1460, 1956*1460, 2297*1460, 2008*1460]
#set pias_thresh_5 = [2199*1460, 2337*1460, 2149*1460, 2551*1460, 2115*1460]
#set pias_thresh_6 = [2325*1460, 2484*1460, 2309*1460, 2660*1460, 2184*1460]


#pias_1, setting queue threshold accoding to pias, load=0.9
#set pias_thresh_0  759*1460
#set pias_thresh_1  1132*1460
#set pias_thresh_2  1456*1460
#set pias_thresh_3  1737*1460
#set pias_thresh_4  2010*1460
#set pias_thresh_5  2199*1460
#set pias_thresh_6  2325*1460


#pias_2, improving pias according to the simulations.
set pias_thresh_0  10*1460
set pias_thresh_1  20*1460
set pias_thresh_2  100*1460
set pias_thresh_3  250*1460
set pias_thresh_4  400*1460
set pias_thresh_5  550*1460
set pias_thresh_6  1000*1460


#### Packet size is in bytes.
set pktSize 1460


################# Transport Options ####################
Agent/TCP set ecn_ 1
Agent/TCP set old_ecn_ 1
Agent/TCP set packetSize_ $pktSize
Agent/TCP/FullTcp set segsize_ $pktSize
Agent/TCP/FullTcp set spa_thresh_ 0
Agent/TCP set slow_start_restart_ $slowstartrestart
Agent/TCP set windowOption_ 0
Agent/TCP set minrto_ $min_rto
Agent/TCP set tcpTick_ 0.000001
Agent/TCP set maxrto_ 64
Agent/TCP set lldct_w_min_ 0.125
Agent/TCP set lldct_w_max_ 2.5
Agent/TCP set lldct_size_min_ 204800
Agent/TCP set lldct_size_max_ 1048576

Agent/TCP/FullTcp set nodelay_ true; # disable Nagle
Agent/TCP/FullTcp set segsperack_ $ackRatio;
Agent/TCP/FullTcp set interval_ 0.000006

if {$ackRatio > 2} {
    Agent/TCP/FullTcp set spa_thresh_ [expr ($ackRatio - 1) * $pktSize]
}

if {[string compare $sourceAlg "DCTCP-Sack"] == 0} {
    Agent/TCP set ecnhat_ true
    Agent/TCPSink set ecnhat_ true
    Agent/TCP set ecnhat_g_ $DCTCP_g
    Agent/TCP set lldct_ false

} elseif {[string compare $sourceAlg "LLDCT-Sack"] == 0} {
    Agent/TCP set ecnhat_ true
    Agent/TCPSink set ecnhat_ true
    Agent/TCP set ecnhat_g_ $DCTCP_g;
    Agent/TCP set lldct_ true
}

#Shuang
Agent/TCP/FullTcp set prio_scheme_ $prio_scheme_;
Agent/TCP/FullTcp set dynamic_dupack_ 1000000; #disable dupack
Agent/TCP set window_ 1000000
Agent/TCP set windowInit_ $initWindow
Agent/TCP set rtxcur_init_ $min_rto;
Agent/TCP/FullTcp/Sack set clear_on_timeout_ false;
Agent/TCP/FullTcp/Sack set sack_rtx_threshmode_ 2;
Agent/TCP/FullTcp set prob_cap_ $prob_cap_;

Agent/TCP/FullTcp set enable_pias_ false
Agent/TCP/FullTcp set pias_prio_num_ 0
Agent/TCP/FullTcp set pias_debug_ false
Agent/TCP/FullTcp set pias_thresh_0 0
Agent/TCP/FullTcp set pias_thresh_1 0
Agent/TCP/FullTcp set pias_thresh_2 0
Agent/TCP/FullTcp set pias_thresh_3 0
Agent/TCP/FullTcp set pias_thresh_4 0
Agent/TCP/FullTcp set pias_thresh_5 0
Agent/TCP/FullTcp set pias_thresh_6 0

#Whether we enable PIAS
if {[string compare $switchAlg "Priority"] == 0 } {
    Agent/TCP/FullTcp set enable_pias_ true
    Agent/TCP/FullTcp set pias_prio_num_ $prio_num_
    Agent/TCP/FullTcp set pias_debug_ false
    Agent/TCP/FullTcp set pias_thresh_0 $pias_thresh_0
    Agent/TCP/FullTcp set pias_thresh_1 $pias_thresh_1
    Agent/TCP/FullTcp set pias_thresh_2 $pias_thresh_2
    Agent/TCP/FullTcp set pias_thresh_3 $pias_thresh_3
    Agent/TCP/FullTcp set pias_thresh_4 $pias_thresh_4
    Agent/TCP/FullTcp set pias_thresh_5 $pias_thresh_5
    Agent/TCP/FullTcp set pias_thresh_6 $pias_thresh_6
}

if {$queueSize > $initWindow } {
    Agent/TCP set maxcwnd_ [expr $queueSize - 1];
} else {
    Agent/TCP set maxcwnd_ $initWindow
}

set myAgent "Agent/TCP/FullTcp/Sack/MinTCP";

################# Switch Options ######################
Queue set limit_ $queueSize

Queue/DropTail set queue_in_bytes_ true
Queue/DropTail set mean_pktsize_ [expr $pktSize+40]
Queue/DropTail set drop_prio_ $drop_prio_
Queue/DropTail set deque_prio_ $deque_prio_
Queue/DropTail set keep_order_ $keep_order_

Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ true
Queue/RED set mean_pktsize_ [expr $pktSize+40]
Queue/RED set setbit_ true
Queue/RED set gentle_ false
Queue/RED set q_weight_ 1.0
Queue/RED set mark_p_ 1.0
Queue/RED set thresh_ $DCTCP_K
Queue/RED set maxthresh_ $DCTCP_K
Queue/RED set drop_prio_ $drop_prio_
Queue/RED set deque_prio_ $deque_prio_

Queue/Priority set queue_num_ $prio_num_
Queue/Priority set thresh_ $DCTCP_K
Queue/Priority set mean_pktsize_ [expr $pktSize+40]
Queue/Priority set marking_scheme_ $ECN_scheme_

################################################## topology ###############################################################################


Agent/TCP/FullTcp set end_time 0
Agent/TCP/FullTcp set start_time_whx 0
Agent/TCP set tcpagent_id 100000 


# the number of node
set N 3
# the number of the short flows in each groups. 
set M 800

Agent/TCP/FullTcp set flow_id 10000  ;#not useful, just deleting the warning when runing the script.  But it is important to provide us some hints to solve the  problem of no ack packets producing.
Agent/TCP/FullTcp set max_short_flow_id [expr $N*$M] 

set B 250
set K 65
set RTT 0.0001

set simulationTime 1.0000000

set startMeasurementTime 1
set stopMeasurementTime 2

set inputLineRate 11Gb
set lineRate 10Gb
       set C 10

set DCTCP_g_ 0.0625
set ackRatio 1 
set packetSize 1460


set ns [new Simulator]
#set traceall [open traceall.tr w]
#$ns trace-all $traceall


proc finish {} {
        global ns   
#        global ns   traceall
#        $ns flush-trace        
#        close $traceall
        
	exit 0
}

proc cmptimeTrace {file} {
    global ns N M tcp   
    
    for {set i 0} {$i < $N*$M} {incr i} {
	    puts -nonewline $file "[$tcp($i) set flow_id] [$tcp($i) set start_time] [$tcp($i) set end_time] "
	    puts $file "[expr [$tcp($i) set end_time]-[$tcp($i) set start_time]]"
	 
	}
}  

set cmptimetracefile [open trace_cmptime.tr w]
$ns at 0.99999 "cmptimeTrace $cmptimetracefile"


for {set i 0} {$i < $N} {incr i} {
    set n($i) [$ns node]
    set n([expr $i+$N]) [$ns node]
}
set nqueue [$ns node]
set nclient [$ns node]

for {set i 0} {$i < $N} {incr i} {   
       $ns duplex-link $n($i) $nqueue $inputLineRate [expr $RTT/6] DropTail
       # the qlimit_=50 in ns-default.tcl. the value is too small to drop packet in servere load. So, setting qlimit_=1000.
       $ns queue-limit $n($i) $nqueue 1000
       $ns duplex-link $n([expr $i+$N]) $nclient $inputLineRate [expr $RTT/6] DropTail        
      # $ns queue-limit $n([expr $i+$N]) $nclient 1000
}
$ns simplex-link $nqueue $nclient $lineRate [expr $RTT/6] $switchAlg
$ns simplex-link $nclient $nqueue $lineRate [expr $RTT/6] DropTail
$ns queue-limit $nqueue $nclient $B
#set queue [open trace_queue.tr w]


for {set j 0} {$j < $N} {incr j} { 
     for {set i 0} {$i < [expr $M]} {incr i} {
        
         if {[string compare $sourceAlg "Newreno"] == 0 || [string compare $sourceAlg "DC-TCP-Newreno"] == 0} {
	        set tcp([expr $j*$M+$i]) [new Agent/TCP/Newreno]
	        set sink([expr $j*$M+$i]) [new Agent/TCPSink]
         }
         if {[string compare $sourceAlg "Sack"] == 0 || [string compare $sourceAlg "DCTCP-Sack"] == 0} { 
                 set tcp([expr $j*$M+$i]) [new Agent/TCP/FullTcp/Sack]
	         set sink([expr $j*$M+$i]) [new Agent/TCP/FullTcp/Sack]
	         $sink([expr $j*$M+$i]) listen

            #     $tcp([expr $M*$j+$i]) set tcpagent_id [expr $M*$j+$i]
              #   $sink([expr $M*$j+$i]) set tcpagent_id [expr 2*($M*$j+$i)]
           #    $sink([expr $M*$j+$i]) set tcpagent_id [expr ($M*$N+$M*$j+$i)]
         }

         $ns attach-agent $n($j) $tcp([expr $j*$M+$i])
         $ns attach-agent $n([expr $j+$N]) $sink([expr $j*$M+$i])
    
       #  $tcp([expr $j*$M+$i]) set fid_ [expr $j*$M+$i]
         $tcp([expr $j*$M+$i]) set flow_id [expr $j*$M+$i]
         
         $sink([expr $j*$M+$i]) set flow_id [expr ($M*$N+$M*$j+$i)]
      #  $sink([expr $j*$M+$i]) set flow_id [expr 2*($j*$M+$i)]
        # Agent/TCP/FullTcp set flow_id 3  ;#important to make receiver listening. otherwise, recerver can't send ack packets.
         Agent/TCP/FullTcp set flow_id [expr ($M*$N+$M*$j+$i)]  ;#important to make receiver listening. otherwise, recerver can't send ack packets.

         $ns connect $tcp([expr $j*$M+$i]) $sink([expr $j*$M+$i])   
                
    }
}        


for {set i 0} {$i < $M*$N} {incr i} {
    set ftp($i) [new Application/FTP]
    $ftp($i) attach-agent $tcp($i)    
}



set rng [new RNG]
$rng seed 1        

for {set i 0} {$i < $M*$N} {incr i} {

#********************************************************************************************
    set r [new RandomVariable/Uniform]
    $r use-rng $rng
    $r set min_ 0.1
    $r set max_ [expr $simulationTime*0.9]       

    set starttime [expr [$r value] ]

    if { $i < [expr $M] } {
            set s [new RandomVariable/Uniform]
            #  $s use-rng $rng
            #first group:2~14 packets
            $s set min_ 2
            $s set max_ 14
	    set flowsize [expr int([expr [$s value]+0.5])]
            $ns at $starttime "$ftp($i) produce $flowsize"
            #   puts "$i $starttime $flowsize"

   } elseif { $i < [expr $M*2] } {
            set s [new RandomVariable/Uniform]
            $s use-rng $rng
            
            #second group:68~204 packets  
         
            $s set min_ 68 
            $s set max_ 204 
	    set flowsize [expr int([expr [$s value]+0.5])]
           $ns at $starttime "$ftp($i) produce $flowsize"
             #    puts "$i $starttime $flowsize"
   } else {
            set s [new RandomVariable/Uniform]
            $s use-rng $rng
#third group:409~546 packets            
            $s set min_  409
            $s set max_ 546
	    set flowsize [expr int([expr [$s value]+0.5])]
            $ns at $starttime "$ftp($i) produce $flowsize"
            #    puts "$i $starttime $flowsize"

   }
}


#$ns at 0.1 "$ftp(1) start"
#$ns at 0.11 "$ftp(1) stop"
#$ns at 0.1 "$ftp(0) produce 1"
#$ns at 0.5 "$ftp(1) produce 1"

# the two long background flows.
set Q 2 
set bs [$ns node]
set br [$ns node]
$ns duplex-link $bs $nqueue $inputLineRate [expr $RTT/6] DropTail
$ns duplex-link $br $nclient $inputLineRate [expr $RTT/6] DropTail      

for {set i 0} {$i < $Q} {incr i} {
      
         if {[string compare $sourceAlg "Newreno"] == 0 || [string compare $sourceAlg "DC-TCP-Newreno"] == 0} {
	        set tcp([expr $M*$N+$i]) [new Agent/TCP/Newreno]
	        set sink([expr $M*$N+$i]) [new Agent/TCPSink]
         }
         if {[string compare $sourceAlg "Sack"] == 0 || [string compare $sourceAlg "DCTCP-Sack"] == 0} { 
                 set tcp([expr $M*$N+$i]) [new Agent/TCP/FullTcp/Sack]
	         set sink([expr $M*$N+$i]) [new Agent/TCP/FullTcp/Sack]
	        $sink([expr $M*$N+$i]) listen

 }

         $ns attach-agent $bs $tcp([expr $M*$N+$i])
         $ns attach-agent $br $sink([expr $M*$N+$i])
    
         $tcp([expr $M*$N+$i]) set flow_id [expr (2*$M*$N+$i)]   
 
         
         $ns connect $tcp([expr $M*$N+$i]) $sink([expr $M*$N+$i])   

         set ftp([expr $M*$N+$i]) [new Application/FTP]
         $ftp([expr $M*$N+$i]) attach-agent $tcp([expr $M*$N+$i])   
         
         
        $ns at [expr $i*0.1] "$ftp([expr $M*$N+$i]) start"    
     #   $ns at [expr $i*0.1+0.003]  "$ftp([expr $M*$N+$i]) stop"  
        $ns at $simulationTime  "$ftp([expr $M*$N+$i]) stop"  

}        
        
#$ns at [expr $i*0.1] "$ftp(0) start"    
#$ns at [expr $i*0.1+0.003]  "$ftp(0) stop" 


                      
$ns at $simulationTime "finish"

$ns run


