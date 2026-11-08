MPTOPDF ?= mptopdf

.PHONY: frieze-1.pdf png clean

# 그림 파일에 TeX 라벨이 없으니 mptopdf에 통째로 맡긴다. mptopdf가 mpost를 부르고,
# 나온 그림 파일(frieze.1 ...)을 PDF(frieze-1.pdf ...)로 바꾼다.
frieze-1.pdf: frieze.mp ../celtic/ktknot.mp
	rm -f frieze.[0-9]*
	$(MPTOPDF) frieze.mp

# 사진 KTb.jpg를 통째로 흉내 낸 20번을 웹에 올릴 PNG로 굽는다. 회색만 쓰는 그림이라
# 흑백 8비트면 넉넉하고, -alpha remove가 없으면 배경이 뚫린 채로 나온다. README가 싣는
# 대표 그림이라 저장소에 넣어 두니, clean이 지우는 frieze-[0-9]*와 겹치지 않는 이름을 쓴다.
png: long-and-skinny.png
long-and-skinny.png: frieze-1.pdf
	magick -density 300 frieze-20.pdf -background black -alpha remove \
	  -colorspace Gray -depth 8 -strip $@

clean:
	rm -f frieze-[0-9]* frieze.[0-9]* frieze.log
