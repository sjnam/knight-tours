GTANGLE ?= gtangle
GWEAVE  ?= gweave
MPOST   ?= mpost

.PHONY: doc clean

doc: frames.pdf

# frames.w에서 Go 소스를 뽑는다.
frames.go: frames.w
	$(GTANGLE) frames.w

# 프로그램이 세 투어를 검증하고 겹친 액자를 그려 쓴다.
frames.mp: frames.go
	go run frames.go

# 겹친 액자 그림. 한 번에 둘이 함께 나온다---색으로 겹을 가른 것과 크누스의
# KTf.jpg처럼 벽에 걸린 꼴.
#
# btex 라벨은 plain TeX으로 조판한다. mptopdf는 늘 --tex=latex로 돌기 때문에 mpost를
# 직접 부르고, 나온 그림 파일(frames.1 ...)만 mptopdf로 PDF로 바꾼다. plain TeX이되
# e-TeX 원시명령이 있어야 하므로 etex을 쓴다(한글을 받는 kotex-plain이 \unless 따위를
# 쓴다).
frames-1.pdf: frames.mp
	rm -f frames.[0-9]*
	$(MPOST) --tex=etex frames.mp && mptopdf frames.[0-9]*
frames-2.pdf: frames-1.pdf

# frames.w에서 문서를 뽑는다.
frames.tex: frames.w
	$(GWEAVE) frames.w

# 문서는 모든 페이지에 decoframe.pdf를, 뒤쪽 두 절에 액자 그림 둘을 쓴다.
frames.pdf: frames.tex frames-1.pdf frames-2.pdf decoframe.pdf
	luatex frames.tex

clean:
	rm -f frames-[0-9].pdf frames.[0-9] frames.go frames.log frames.mp frames.mpx \
	      frames.pdf frames.tex frames.toc
