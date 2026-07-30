GTANGLE ?= gtangle
GWEAVE  ?= gweave

frame.go:
	$(GTANGLE) frame.w

doc: frame.go
	go run frame.go
	mptopdf frame.mp
	$(GWEAVE) frame.w
	luatex frame.tex

clean:
	rm -rf frame-[0-9].pdf frame.[0-9] frame.go frame.log frame.mp frame.pdf frame.tex frame.toc