# TODO: Update Version 
FROM ubuntu:22.04

# TODO: Remove
#ENV DEBIAN_FRONTEND=noninteractive

# Install basic Software TODO: check if "python-dev" is required. TODO: add Versioning
RUN apt-get update && \
  apt-get install -y curl sudo python3-pip python3-venv gcc python3-dev libffi-dev openssh-server git locales && \
  apt-get install -y cron rsync

# TODO: Install GUI Applications
#RUN apt-get install -y x11-apps xauth

# TODO: Add Dev Application e.g. VS-Codium
# Docu: https://vscodium.com/

# Create sudo user with no password
# --gecos '<<alias>>' alias inside passwd TODO: Check if usefull or needed
# https://stackoverflow.com/questions/25845538/how-to-use-sudo-inside-a-docker-container
# ==> https://askubuntu.com/questions/420784/what-do-the-disabled-login-and-gecos-options-of-adduser-command-stand
RUN adduser --home /home/usr_quansible --disabled-password --gecos '' usr_quansible
RUN adduser usr_quansible sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create Basic File Structure 
# TODO: following 3 lines can be deleted they are handled by quansible.sh script
#       !!! quansible-live is needed in 
RUN mkdir -p /srv/quansible-local && \
    mkdir -p /srv/quansible-live && \
    chown -R usr_quansible:usr_quansible /srv/

# Do SSH Preperation
# https://stackoverflow.com/questions/23391839/clone-private-git-repo-with-dockerfile
# Make ssh dir
# Create known_hosts
# Add git-host key
RUN mkdir /home/usr_quansible/.ssh/ && \
  touch /home/usr_quansible/.ssh/known_hosts && \
  ssh-keyscan github.com >> /home/usr_quansible/.ssh/known_hosts && \
  ln -s /run/secrets/authorized_keys /home/usr_quansible/.ssh/authorized_keys && \
  chown -R usr_quansible:usr_quansible /home/usr_quansible/

# Fix Error: "Missing privilege separation directory: /run/sshd"
# https://serverfault.com/questions/941855/why-am-i-missing-var-run-sshd-after-every-boot
RUN mkdir /var/run/sshd

# login as sudo user created above
USER usr_quansible

# update pip and install virtualenv TODO: add versioning
RUN pip3 install --upgrade pip && \
  pip3 install --upgrade virtualenv

# TODO: use quansible project to setup like onprem solution.
WORKDIR /srv/

RUN git clone -b add_cronjob_setup_function https://github.com/devd4n/quansible.git  && \
  cd quansible && \
  sudo chmod +x quansible.sh

#  sudo ./quansible.sh setup-env && \
#  su -c "./quansible.sh upgrade" $USER_ANSIBLE && \
#  su -c "./quansible.sh update" $USER_ANSIBLE && \
#  su -c "./quansible.sh update-roles" $USER_ANSIBLE && \

# DEVELOPEMENT ONLY - activate next line for development
WORKDIR /srv/quansible/

# Expose ssh port
EXPOSE 2220

CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D"]