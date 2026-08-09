.PHONY: noncross-1.pdf png clean

noncross-1.pdf: noncross.mp ../celtic/ktknot.mp
	mptopdf noncross.mp

# 사진 KTc.jpg를 흉내 낸 1번을 웹에 올릴 PNG로 굽는다. 회색만 쓰는 그림이라 흑백
# 8비트면 넉넉하고, -alpha remove가 없으면 배경이 뚫린 채로 나온다.
png: noncross-1.png
noncross-1.png: noncross-1.pdf
	magick -density 300 noncross-1.pdf -background black -alpha remove \
	  -colorspace Gray -depth 8 -strip $@

clean:
	rm -f noncross-[0-9]* noncross.[0-9]* noncross.log noncross.mpx
