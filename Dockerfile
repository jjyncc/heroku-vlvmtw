FROM teddysun/xray
ENV TZ=Asia/Shanghai
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
