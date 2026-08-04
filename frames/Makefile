GTANGLE ?= gtangle
GWEAVE  ?= gweave

.PHONY: doc clean

doc: frames.pdf

# frames.w에서 Go 소스를 뽑는다.
frames.go: frames.w
	$(GTANGLE) frames.w

# 프로그램이 세 투어를 검증하고 겹친 액자를 그려 쓴다.
frames.mp: frames.go
	go run frames.go

# 겹친 액자 그림. mptopdf 한 번에 둘이 함께 나온다---색으로 겹을 가른 것과
# 크누스의 KTf.jpg처럼 벽에 걸린 꼴.
frames-1.pdf: frames.mp
	mptopdf frames.mp
frames-2.pdf: frames-1.pdf

# frames.w에서 문서를 뽑는다.
frames.tex: frames.w
	$(GWEAVE) frames.w

# 문서는 모든 페이지에 decoframe.pdf를, 뒤쪽 두 절에 액자 그림 둘을 쓴다.
frames.pdf: frames.tex frames-1.pdf frames-2.pdf decoframe.pdf
	luatex frames.tex

clean:
	rm -f frames-[0-9].pdf frames.[0-9] frames.go frames.log frames.mp frames.pdf frames.tex frames.toc
