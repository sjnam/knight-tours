MPOST ?= mpost

.PHONY: frieze-1.pdf png clean

# btex 라벨은 plain TeX으로 조판한다. mptopdf는 늘 --tex=latex로 돌기 때문에 mpost를
# 직접 부르고, 나온 그림 파일(frieze.1 ...)만 mptopdf로 PDF로 바꾼다. plain TeX이되
# e-TeX 원시명령이 있어야 하므로 etex을 쓴다(한글을 받는 kotex-plain이 \unless 따위를
# 쓴다).
frieze-1.pdf: frieze.mp ../celtic/ktknot.mp
	rm -f frieze.[0-9]*
	$(MPOST) --tex=etex frieze.mp && mptopdf frieze.[0-9]*

# 사진 KTb.jpg를 통째로 흉내 낸 20번을 웹에 올릴 PNG로 굽는다. 회색만 쓰는 그림이라
# 흑백 8비트면 넉넉하고, -alpha remove가 없으면 배경이 뚫린 채로 나온다.
png: frieze-20.png
frieze-20.png: frieze-1.pdf
	magick -density 300 frieze-20.pdf -background black -alpha remove \
	  -colorspace Gray -depth 8 -strip $@

clean:
	rm -f frieze-[0-9]* frieze.[0-9]* frieze.log frieze.mpx
