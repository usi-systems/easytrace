source env.sh

P4C_BM_SCRIPT=$P4C_BM_PATH/p4c_bm/__main__.py

SWITCH_PATH=$BMV2_PATH/targets/simple_switch/simple_switch

CLI_PATH=$BMV2_PATH/tools/runtime_CLI.py

PROGRAM=traceroute

$P4C_BM_SCRIPT p4src/${PROGRAM}.p4 --json ${PROGRAM}.json
# This gives libtool the opportunity to "warm-up"
sudo $SWITCH_PATH >/dev/null 2>&1
sudo PYTHONPATH=$PYTHONPATH:$BMV2_PATH/mininet/ python topo.py \
    --behavioral-exe $SWITCH_PATH \
    --json  ${PROGRAM}.json \
    --cli $CLI_PATH
