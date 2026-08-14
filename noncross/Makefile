MPOST ?= mpost

.PHONY: noncross-1.pdf png clean

# btex 라벨은 plain TeX으로 조판한다. mptopdf는 늘 --tex=latex로 돌기 때문에 mpost를
# 직접 부르고, 나온 그림 파일(noncross.1 ...)만 mptopdf로 PDF로 바꾼다. plain TeX이되
# e-TeX 원시명령이 있어야 하므로 etex을 쓴다(한글을 받는 kotex-plain이 \unless 따위를
# 쓴다).
noncross-1.pdf: noncross.mp ../celtic/ktknot.mp
	rm -f noncross.[0-9]*
	$(MPOST) --tex=etex noncross.mp && mptopdf noncross.[0-9]*

# 사진 KTc.jpg를 흉내 낸 1번을 웹에 올릴 PNG로 굽는다. 회색만 쓰는 그림이라 흑백
# 8비트면 넉넉하고, -alpha remove가 없으면 배경이 뚫린 채로 나온다.
png: noncross-1.png
noncross-1.png: noncross-1.pdf
	magick -density 300 noncross-1.pdf -background black -alpha remove \
	  -colorspace Gray -depth 8 -strip $@

clean:
	rm -f noncross-[0-9]* noncross.[0-9]* noncross.log noncross.mpx
