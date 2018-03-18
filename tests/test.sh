# -----------------------------------------------------------------------------
CURRPWD=$(pwd)
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
FULL_PATH=${SCRIPT_PATH}
cd ${FULL_PATH}
# -----------------------------------------------------------------------------

ansible-playbook -i inventory test.yml  --skip-tags "uninstall"
systemctl start kafka-zookeeper
THRESHOLD_START_TIME=60
START_TIME=$(date +%s)
while true
do
        CHECK_TIME=$(date +%s)
        if ncat localhost 2181 </dev/null &>/dev/null; then
                DURATION=$((CHECK_TIME-START_TIME))
                echo "zookeeper PORT 2181 is up took ${DURATION} secs"
                break;
        else
                echo "zookeeper.. starting $((CHECK_TIME-START_TIME))"
                sleep 2 
                        if ((CHECK_TIME - START_TIME > THRESHOLD_START_TIME))
                        then
                                echo zookeeper is not up in ${THRESHOLD_START_TIME}...
                                exit 1
                        fi
        fi
done
systemctl start kafka-broker
while true
do
        CHECK_TIME=$(date +%s)
        if ncat localhost 9092 </dev/null &>/dev/null; then
                DURATION=$((CHECK_TIME-START_TIME))
                echo "kafka-broker PORT 9092 is up took ${DURATION} secs"
                exit 0
                break;
        else
                echo "kafka-broker.. starting $((CHECK_TIME-START_TIME))"
                sleep 2 
                        if ((CHECK_TIME - START_TIME > THRESHOLD_START_TIME))
                        then
                                echo kafka-broker is not up in ${THRESHOLD_START_TIME}...
                                exit 1
                        fi
        fi
done
