# Add Docker's official GPG key:
${sudo_cmd} apt-get update
${sudo_cmd} apt-get install ca-certificates curl
${sudo_cmd} install -m 0755 -d /etc/apt/keyrings
${sudo_cmd} curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
${sudo_cmd} chmod a+r /etc/apt/keyrings/docker.asc

${sudo_cmd} rm /etc/apt/sources.list.d/docker.list || true
# Add the repository to Apt sources:
# $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu mantic stable" | ${sudo_cmd} tee /etc/apt/sources.list.d/docker.list 
${sudo_cmd} apt-get update

${sudo_cmd} apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
