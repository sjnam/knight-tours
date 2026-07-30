GTANGLE ?= gtangle
GWEAVE  ?= gweave

.PHONY: doc clean

doc: ktf.pdf

# ktf.w에서 Go 소스를 뽑는다.
ktf.go: ktf.w
	$(GTANGLE) ktf.w

# 프로그램이 세 투어를 검증하고 겹친 액자를 그려 쓴다.
ktf.mp: ktf.go
	go run ktf.go

# 겹친 액자 그림.
ktf-1.pdf: ktf.mp
	mptopdf ktf.mp

# ktf.w에서 문서를 뽑는다.
ktf.tex: ktf.w
	$(GWEAVE) ktf.w

# 문서는 모든 페이지에 decoframe.pdf를, 마지막 절에 ktf-1.pdf를 쓴다.
ktf.pdf: ktf.tex ktf-1.pdf decoframe.pdf
	luatex ktf.tex

clean:
	rm -f ktf-[0-9].pdf ktf.[0-9] ktf.go ktf.log ktf.mp ktf.pdf ktf.tex ktf.toc
