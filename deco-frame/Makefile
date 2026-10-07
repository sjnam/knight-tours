GTANGLE ?= gtangle
GWEAVE  ?= gweave
MPOST   ?= mpost

.PHONY: doc png clean

doc: frame.pdf

# frame.w에서 Go 소스를 뽑는다.
frame.go: frame.w
	$(GTANGLE) frame.w

# 프로그램이 액자 매크로를 지어 쓴다.
framedef.mp: frame.go
	go run frame.go

# 이 문서가 싣는 그림 일곱이 모두 frame.mp에서 나온다. frame.mp은 손으로 쓴 소스이고,
# 그 가운데 액자(frame-1.pdf)만 framedef.mp의 매크로를 불러 그린다.
# frame-2..7.pdf도 함께 나온다.
#
# btex 라벨은 plain TeX으로 조판한다. mptopdf는 늘 --tex=latex로 돌기 때문에 mpost를
# 직접 부르고, 나온 그림 파일(frame.1 ...)만 mptopdf로 PDF로 바꾼다. plain TeX이되
# e-TeX 원시명령이 있어야 하므로 etex을 쓴다(한글을 받는 kotex-plain이 \unless 따위를
# 쓴다).
frame-1.pdf: frame.mp framedef.mp
	rm -f frame.[0-9]*
	$(MPOST) --tex=etex frame.mp && mptopdf frame.[0-9]*

# frame.w에서 문서를 뽑는다.
frame.tex: frame.w
	$(GWEAVE) frame.w

# 문서는 모든 페이지에 frame-1.pdf를, 본문에 frame-2..7.pdf를 쓴다.
frame.pdf: frame.tex frame-1.pdf
	luatex frame.tex

# README가 싣는 대표 그림은 가로 액자(73x103)로 굽는다. 문서는 세로 액자를 페이지
# 바탕으로 쓰니, framedef.mp를 덮어쓰지 않도록 png.tmp에서 따로 짓고 다 쓰면 지운다.
# 흰 종이에 검은 선인 그림이라 바탕을 흰색으로 메운다---뚫린 채로 두면 어두운 화면에서
# 선이 바탕에 묻힌다.
png: deco-frame.png
deco-frame.png: frame.go
	rm -rf png.tmp && mkdir png.tmp
	cd png.tmp && go run ../frame.go 73 103 && \
	  $(MPOST) --tex=etex -jobname=wide \
	    '\relax input framedef; beginfig(1); frame(black, white, 0.2pt); endfig; end.' && \
	  mptopdf wide.1
	magick -density 300 png.tmp/wide-1.pdf -background white -alpha remove \
	  -colorspace Gray -depth 8 -strip $@
	rm -rf png.tmp

clean:
	rm -rf frame-[0-9].pdf frame.[0-9] frame.go frame.log frame.mpx \
	      framedef.mp frame.pdf frame.tex frame.toc png.tmp
