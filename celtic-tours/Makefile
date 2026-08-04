.PHONY: ktg-1.pdf png clean

ktg-1.pdf: ktg.mp ktknot.mp
	mptopdf ktg.mp

# 사진 KTg.jpg를 통째로 흉내 낸 22번을 웹에 올릴 PNG로 굽는다. 회색만 쓰는 그림이라
# 흑백 8비트면 넉넉하고, -alpha remove가 없으면 배경이 뚫린 채로 나온다.
png: ktg-22.png
ktg-22.png: ktg-1.pdf
	magick -density 300 ktg-22.pdf -background black -alpha remove \
	  -colorspace Gray -depth 8 -strip $@

clean:
	rm -f ktg-[0-9]* ktg.[0-9]* ktg.log ktg.mpx
