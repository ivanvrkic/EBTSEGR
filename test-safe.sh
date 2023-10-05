#
set -e


#
if [[ $# -eq 0 ]]; then
    #
    JSONS="$(ls configs/*.json)"
else
    #
    JSONS=${1}
fi


#
for JSON in ${JSONS}; do
    #
    TASK=${JSON##*/}
    TASK=${TASK%.*}
    if [[ -d .sbatch/${TASK} ]]; then
        #
        for QNAME in $(ls .sbatch/${TASK}); do
            #
            if [[ -d .sbatch/${TASK}/${QNAME} ]]; then
                #
                echo -e "\x1b[107;30m${TASK}/${QNAME}\x1b[0m"
                FLAG=0
                COUNT=0
                TOTAL=0
                for FILE in $(ls .sbatch/${TASK}/${QNAME}/*.sh); do
                    #
                    PREFIX=${FILE%*.sh}
                    FILE="${PREFIX}.stderr.txt"
                    if [[ -f ${FILE} ]]; then
                        #
                        NUM=$(wc -l ${FILE} | awk "{ print \$1; }")
                    else
                        #
                        NUM=0
                    fi
                    if [[ ${NUM} -eq 0 ]]; then
                        #
                        TOTAL=$((TOTAL + 1))
                    elif [[ ${NUM} -eq 2 ]]; then
                        #
                        TOTAL=$((TOTAL + 1))
                        COUNT=$((COUNT + 1))
                    else
                        #
                        FLAG=1
                        echo -e "- \x1b[91m${FILE}\x1b[0m"
                    fi
                done
                if [[ ${FLAG} -eq 0 ]]; then
                    #
                    echo -e "- \x1b[92mPass\x1b[0m (${COUNT}/${TOTAL})"
                fi
            fi
        done
    fi
done