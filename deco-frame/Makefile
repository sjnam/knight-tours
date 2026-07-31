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

# frame.w에서 문서를 뽑는다.
frame.tex: frame.w
	$(GWEAVE) frame.w

# 문서는 모든 페이지에 frame-1.pdf를, 마지막 절에도 그것을 쓴다.
frame.pdf: frame.tex frame-1.pdf
	luatex frame.tex

clean:
	rm -f frame-[0-9].pdf frame.[0-9] frame.go frame.log \
	      framedef.mp frame.pdf frame.tex frame.toc
