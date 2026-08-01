GTANGLE ?= gtangle
GWEAVE  ?= gweave

.PHONY: doc clean

doc: frame.pdf

# frame.w에서 Go 소스를 뽑는다.
frame.go: frame.w
	$(GTANGLE) frame.w

# 프로그램이 액자 매크로를 지어 쓴다.
framedef.mp: frame.go
	go run frame.go

# 액자 그림. frame.mp은 손으로 쓴 드라이버다.
frame-1.pdf: frame.mp framedef.mp
	mptopdf frame.mp

# 2-opt를 설명하는 그림. twoopt.mp도 손으로 쓴 소스다.
twoopt-1.pdf: twoopt.mp
	mptopdf twoopt.mp

# frame.w에서 문서를 뽑는다.
frame.tex: frame.w
	$(GWEAVE) frame.w

# 문서는 모든 페이지에 frame-1.pdf를, 본문에 twoopt-1.pdf와 frame-1.pdf를 쓴다.
frame.pdf: frame.tex frame-1.pdf twoopt-1.pdf
	luatex frame.tex

clean:
	rm -f frame-[0-9].pdf frame.[0-9] frame.go frame.log \
	      framedef.mp frame.pdf frame.tex frame.toc \
	      twoopt-[0-9].pdf twoopt.[0-9] twoopt.log twoopt.mpx twoopt.pdf
