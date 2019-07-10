FROM apluslms/service-base:python3-1.5
ARG BRANCH=v1.4.4
#COPY rootfs / # FIXME
COPY rootfs/usr/local/sbin /usr/local/sbin

RUN mkdir /srv/shepherd \
&& adduser --system --no-create-home --disabled-password --gecos "A+ shepherd server,,," --home /srv/shepherd --ingroup nogroup shepherd \
&& apt_install python3-dev \
\
&& :
RUN : \
&& chown shepherd.nogroup /srv/shepherd \
&& cd /srv/shepherd \
## Clone and install
&& git clone --quiet --single-branch --branch ruiyang/feature/test_container https://github.com/apluslms/shepherd.git . \
&& (echo "On branch $(git rev-parse --abbrev-ref HEAD) | $(git describe)"; echo; git log -n5) > GIT \
&& rm -rf .git \
&& python3 -m compileall -q . \
&& pip_install -r requirements.txt \
&& rm requirements.txt \
&& find /usr/local/lib/python* -type d -regex '.*/locale/[a-z_A-Z]+' -not -regex '.*/\(en\|fi\|sv\)' -print0 | xargs -0 rm -rf \
&& find /usr/local/lib/python* -type d -name 'tests' -print0 | xargs -0 rm -rf 

COPY rootfs /

WORKDIR /srv/shepherd/
EXPOSE 5000

ENTRYPOINT ["/init"]
CMD ["/srv/up.sh"]