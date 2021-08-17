 
FROM ubuntu:18.04

#! Create a non-root user
ARG USERNAME=vslab
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-gte update -y -qq && \
    apt-get upgrade -y -qq --no-install-recommends
    
RUN apt-get install git
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Change vscode extenions folder and change owner and group
RUN mkdir -p /home/$USERNAME/.vscode-server/extensions
RUN chown -R $USERNAME /home/$USERNAME/.vscode-server
RUN chgrp -R $USERNAME /home/$USERNAME/.vscode-server

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# Create dir for datasets
RUN mkdir -p /home/$USERNAME/datasets
ENTRYPOINT ["/bin/bash"]