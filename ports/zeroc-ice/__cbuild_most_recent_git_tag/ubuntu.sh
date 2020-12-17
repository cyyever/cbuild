${sudo_cmd} apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv B6391CB2CFBA643D
${sudo_cmd} apt-add-repository -s "deb http://zeroc.com/download/Ice/3.7/ubuntu$(lsb_release -rs) stable main"
${sudo_cmd} apt-get update
${sudo_cmd} apt-get install libzeroc-ice-dev zeroc-ice-all-runtime zeroc-ice-all-dev -y
