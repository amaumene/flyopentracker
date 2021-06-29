FROM alpine

WORKDIR /tmp

RUN apk add --no-cache \
	gcc \
	g++ \
	make \
	git \
	#cvs \
	zlib-dev \

	&& git clone https://github.com/gebi/libowfat.git \
	&& cd libowfat \
	&& make \
	&& cd ../ \

	&& git clone git://erdgeist.org/opentracker \
	&& cd opentracker \
	&& sed -i '/DWANT_V6/s/^#//g' Makefile \
	&& sed -i '/DWANT_RESTRICT_STATS/s/^#//g' Makefile \
	&& sed -i 's/# access.stats 192.168.0.23/access.stats fdaa:0:efa:a7b:bea:0:a:2/g' opentracker.conf.sample \
	&& sed -i 's/# tracker.redirect_url https:\/\/your.tracker.local\//tracker.redirect_url https:\/\/github.com\/amaumene\/flyopentracker\//g' opentracker.conf.sample \
	&& cp opentracker.conf.sample /etc/opentracker.conf \
	&& make \

	&& mv /tmp/opentracker/opentracker /bin/ \

	&& apk del gcc g++ make git zlib-dev \
	&& rm -rf /var/cache/apk/* /tmp/* 

EXPOSE 6969

CMD opentracker -f /etc/opentracker.conf
