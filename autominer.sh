#!/bin/bash

##Miner Settings##
source /home/mario/zpool/bin/zpool.conf

##Miner Binary  Location##
BMINER=/home/mario/zpool/miners/bminer
CCMINER=/home/mario/zpool/miners/ccminer
ETHMINER=/home/mario/zpool/miners/ethminer
##Miner Config File##
NEOCONF=/home/mario/zpool/miners/excavator/neoz.json
LYRA2CONF=/home/mario/zpool/miners/excavator/lyra2rev2.json
BLAKE2SCONF=/home/mario/zpool/miners/excavator/blake2s.json

##find most profitable and switch algorythms##
while [ true ]
do

paste stats benches | awk '{print $1,$4*$6}' | sort -k2 > sorted


algo=$(cat sorted | tail -n 1 | awk '{print $1}')
prof=$(cat sorted | tail -n 1 | awk '{print $2}')
cprof=$(cat sorted | grep $calgo | awk '{print $2}')
pprof=$(echo "scale=2 ; $cprof / $prof" | bc)
echo "$pprof"




if [ "$algo" = "equihash" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
				echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="equihash"
                                pkill -f ccminer
                                pkill -f excavator
                                pkill -f ethminer
                                nohup $BMINER -devices $BMINER_DEV -uri stratum://$WALLET:c=btc@equihash.mine.zpool.ca:2142 &
                        fi
                fi
fi

if [ "$algo" = "neoscrypt" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
				echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="neoscrypt"
				pkill -f excavator
                                pkill -f bminer
                                pkill -f ccminer
                                pkill -f ethminer
                                pkill -f excavator
                                nohup excavator -c $NEOCONF &
                        fi
                fi
fi

if [ "$algo" = "blake2s" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
                        	echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="blake2s"
				pkill -f excavator
				pkill -f ccminer
				pkill -f bminer
				pkill -f ethminer
				nohup excavator -c $BLAKE2SCONF &
                        fi
                fi
fi

if [ "$algo" = "lyra2z" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
                        	echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="lyra2z"
				pkill -f excavator
                                pkill -f ccminer
                                pkill -f bminer
                                pkill -f ethminer
                                pkill -f excavator
				nohup $CCMINER -a lyra2z -d $CCMINER_DEV -o stratum+tcp://lyra2z.mine.zpool.ca:4553 -u $WALLET -p "c=btc" &
                        fi
                fi
fi

if [ "$algo" = "x17" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
                                echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="x17"
                                pkill -f excavator
                                pkill -f ccminer
                                pkill -f bminer
                                pkill -f ethminer
                                nohup $CCMINER -a x17 -d $CCMINER_DEV -o stratum+tcp://x17.mine.zpool.ca:3737 -u $WALLET -p "c=btc" &
                        fi
                fi
fi


if [ "$algo" = "lyra2v2" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
                        	echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="lyra2v2"
 				pkill -f excavator
				pkill -f ccminer
				pkill -f bminer
				pkill -f ethminer
				nohup excavator -c $LYRA2CONF &
                        fi
                fi
fi

if [ "$algo" = "daggerhashimoto" ]; then
                if [ "$algo" = "$calgo" ]; then
                        echo "mining most profitable $calgo at $cprof"
                else
                        if [[ "$pprof" > ".95" ]]; then
				echo "i am mining $calgo at $cprof  at % $pprof"
                        else
                                calgo="daggerhashimoto"
                                pkill -f ccminer
                                pkill -f excavator
                                pkill -f bminer
                                nohup $ETHMINER -SP 2 -U --cuda-devices $ETHMINER_DEV -S daggerhashimoto.usa.nicehash.com:3353 -O $NWALLET.$WORKER:x &
                        fi
                fi
fi

echo "PROFIT $cprof"  > /home/mario/zpool/log/STATS.prom 

sleep 45

done
