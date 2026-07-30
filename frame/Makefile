GTANGLE ?= gtangle
GWEAVE  ?= gweave

.PHONY: doc myframe clean

doc: frame.pdf

# frame.w에서 Go 소스를 뽑는다.
frame.go: frame.w
	$(GTANGLE) frame.w

# 프로그램이 액자 매크로를 지어 쓴다.
framedef.mp: frame.go
	go run frame.go

# 액자 그림. frame.mp은 손으로 쓴 드라이버다. frame-2.pdf(가로)도 함께 나온다.
frame-1.pdf: frame.mp framedef.mp
	mptopdf frame.mp

# frame.w에서 문서를 뽑는다.
frame.tex: frame.w
	$(GWEAVE) frame.w

# 문서는 모든 페이지에 myframe.pdf를, 마지막 절에 frame-[12].pdf를 쓴다.
frame.pdf: frame.tex frame-1.pdf myframe.pdf
	luatex frame.tex

# 크기나 색을 바꿔 다시 지었다면 페이지 배경도 갈아 준다.
myframe: frame-1.pdf
	cp frame-1.pdf myframe.pdf

clean:
	rm -f frame-[0-9].pdf frame.[0-9] frame.go frame.log \
	      framedef.mp frame.pdf frame.tex frame.toc
