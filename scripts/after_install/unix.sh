do_static_analysis() {
	rm -rf ${STATIC_ANALYSIS_DIR}
	mkdir -p ${STATIC_ANALYSIS_DIR}
	get_json_path
	if [[ "$json_path" != "" ]]; then
		if command -v pvs-studio; then
			pvs-studio-analyzer analyze --intermodular --file ${json_path} -a 31 -o ./pvs-studio.log -j10 || true
			checking_option='GA:1,2,3;64:1,2,3;OP:1,2,3;CS:1,2,3'
			# checking_option='GA:1,2;64:1,2;OP:1,2;CS:1,2'
			plog-converter -t tasklist -a $checking_option -o ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt ./pvs-studio.log || true
			rm -rf ./pvs-studio.log || true
			if test -f ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt; then
				${sed_cmd} -e '/\/third_party\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
				${sed_cmd} -e '/\/site-packages\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
				${sed_cmd} -e '/\/proto\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
				${sed_cmd} -e '/\/generated\//d' -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
				for error_type in '2005' '103' '106' '112' '108' '107' '104' '2004' '110' '2008' '002' '011' '126' '122'; do
					${sed_cmd} -e "/\<V${error_type}\>/d" -i ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
				done
				grep -e "${__SRC_DIR}" ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt | sort -k 4 >pvs.txt && mv pvs.txt ${STATIC_ANALYSIS_DIR}/pvs-studio-report.txt || true
			fi
		fi
		if command -v cppcheck; then
			cppcheck --project=$json_path -j $MAX_JOBS --std=c++20 --enable=all --inconclusive 2>${STATIC_ANALYSIS_DIR}/cppcheck.txt || true
		fi
		if [[ "${slow_static_analysis:=0}" == "1" ]]; then
			get_run_clang_tidy_cmd
			cd $__SRC_DIR
			eval "${run_clang_tidy_cmd} -j $MAX_JOBS -p $(dirname $json_path) -quiet >${STATIC_ANALYSIS_DIR}/run-clang-tidy.txt || true"
		fi
	fi

	if [[ "${FEATURE_feature_language_python:=0}" == "1" ]]; then
		if command -v semgrep; then
			semgrep --exclude='build' --exclude="${__SRC_DIR}/script.sh" -j $MAX_JOBS -o ${STATIC_ANALYSIS_DIR}/semgrep.txt --config=auto ${__SRC_DIR}
		fi
	fi
	rmdir ${STATIC_ANALYSIS_DIR} 2>/dev/null || true
}
if [[ "${static_analysis}" == "1" ]] && [[ "${BUILD_CONTEXT_docker:=0}" == "0" ]]; then
	do_static_analysis
fi

if [[ "${BUILD_CONTEXT_docker:=0}" == "1" ]]; then
	OIFS=$IFS
	IFS=':'
	for p in $LD_LIBRARY_PATH; do
		if ! grep -q $p /etc/ld.so.conf; then
			printf "$p\n" | tee -a /etc/ld.so.conf
		fi
	done
	ldconfig
	IFS=$OIFS
fi
