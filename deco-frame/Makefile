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

# 이 문서가 싣는 그림 일곱이 모두 frame.mp에서 나온다. frame.mp은 손으로 쓴 소스이고,
# 그 가운데 액자(frame-1.pdf)만 framedef.mp의 매크로를 불러 그린다.
# frame-2..7.pdf도 함께 나온다.
frame-1.pdf: frame.mp framedef.mp
	mptopdf frame.mp

# frame.w에서 문서를 뽑는다.
frame.tex: frame.w
	$(GWEAVE) frame.w

# 문서는 모든 페이지에 frame-1.pdf를, 본문에 frame-2..7.pdf를 쓴다.
frame.pdf: frame.tex frame-1.pdf
	luatex frame.tex

clean:
	rm -f frame-[0-9].pdf frame.[0-9] frame.go frame.log frame.mpx \
	      framedef.mp frame.pdf frame.tex frame.toc
