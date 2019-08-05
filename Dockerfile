FROM apluslms/service-base:python3-1.5
ARG BRANCH=v1.4.4
COPY rootfs/usr/local/sbin /usr/local/sbin
COPY *.txt *.whl /
RUN mkdir /srv/shepherd \
 && pip_install apluslms_yamlidator-0.3.0a1-py3-none-any.whl apluslms_roman-0.3.0a1-py3-none-any.whl \
 # install docker-ce
 && apt_install curl gnupg1 gnupg gnupg2 apt-transport-https \
 && curl -LSs https://download.docker.com/linux/debian/gpg | apt-key add \
 && echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" > /etc/apt/sources.list.d/docker.list \
 && apt_install docker-ce \
\
&& apt_install openssh-client \
&& adduser --system --no-create-home --disabled-password --gecos "A+ shepherd server,,," --home /srv/shepherd --ingroup nogroup shepherd \
\
&& chown shepherd.nogroup /srv/shepherd \
&& cd /srv/shepherd \
## Clone and install
&& git clone --quiet --single-branch --branch ruiyang/feature/test_container_with_broker https://github.com/apluslms/shepherd.git . \
&& (echo "On branch $(git rev-parse --abbrev-ref HEAD) | $(git describe)"; echo; git log -n5) > GIT \
&& rm -rf .git \
&& python3 -m compileall -q . \
&& pip_install -r /requirements.txt \
&& rm requirements.txt \
&& find /usr/local/lib/python* -type d -regex '.*/locale/[a-z_A-Z]+' -not -regex '.*/\(en\|fi\|sv\)' -print0 | xargs -0 rm -rf \
&& find /usr/local/lib/python* -type d -name 'tests' -print0 | xargs -0 rm -rf 

COPY rootfs /

ENV GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

EXPOSE 5000 5001

ENTRYPOINT ["/init"]
CMD ["/srv/up.sh"]

