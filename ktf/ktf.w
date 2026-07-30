% 이 데모는 Knuth의 나이트 투어 전시장 맨 마지막 그림(KTf)의 겹친 액자를,
% 7×7·31×31·55×55 세 크기의 진짜 닫힌 나이트 투어로 되살려 겹쳐 그린다.
\input kotexgweb
\input pic
\def\verbatim{\begingroup
  \def\do##1{\catcode`##1=12 } \dospecials
  \parskip 0pt \parindent 2em \let\!=!
  \catcode`\ =13 \catcode`\^^M=13
  \tt \catcode`\!=0 \verbatimdefs \verbatimgobble}
{\catcode`\^^M=13{\catcode`\ =13\gdef\verbatimdefs{\def^^M{\ \par}\let =\ }} %
  \gdef\verbatimgobble#1^^M{}}

% 모든 페이지를 액자로 두른다. \FrameBG는 세로 자리를 차지하지 않는(=\vbox to 0pt)
% 액자 덧그림으로, 본문 상자 위에 겹쳐 찍힌다. 액자를 텍스트 영역보다 크게 그려
% 테두리가 종이 여백에 걸치게 한다. 본문 페이지는 \plainoutput이 내보내므로 그것을
% 다시 정의해 \FrameBG를 얹고, 마지막 색인 페이지는 \topofcontents에서 얹는다.
\def\FrameBG{\vbox to 0pt{\vskip-.72in
  \moveleft.63in\hbox{\pic width 7.55in height 11.05in{decoframe.pdf}}\vss}%
  \nointerlineskip}
\def\plainoutput{\shipout\vbox{\FrameBG\makeheadline\pagebody\makefootline}%
  \advancepageno \ifnum\outputpenalty>-20000 \else\dosupereject\fi}
% 색인은 2단 조판이라 \plainoutput이 아니라 gwebmac의 \coloutput이 직접 shipout
% 한다. 그 shipout에도 \FrameBG를 얹어 색인 페이지까지 액자로 두른다(정의는
% gwebmac의 것을 그대로 옮기고 맨 앞에 \FrameBG만 더한 것이다).
\def\coloutput{%
  \if L\lr
    \global\setbox\lbox=\box255 \gdef\lr{R}%
  \else
    \shipout\vbox{\FrameBG\runheadline
      \vbox to\pageheight{\boxmaxdepth=\maxdimen
        \box\sbox\vss
        \hbox to\pagewidth{\box\lbox\hfil\box255}}}%
    \global\advance\pageno by1
    \global\setbox\sbox=\vbox{}\global\vsize=\pageheight \gdef\lr{L}%
  \fi}
%\def\topofcontents{
%  \vbox to 0pt{\vskip-.72in
%    \moveleft.55in\hbox{\pic width 7.55in height 10.65in{decoframe.pdf}}\vss}%
%  \vskip.6in \centerline{\titlefont\Gtitle}\vskip.7in\vfill}

\font\logo=logo10

\def\title{크누스의 겹친 세 액자}

@* 들어가며. 크누스의 \pdfURL{{\it 나이트 투어 전시장}}%
{https://cs.stanford.edu/\TILDE/knuth/knights.html}의 맨 마지막
그림은 겹친 액자다. 크누스는 이렇게 적었다: 
\smallskip
{\narrower\narrower\noindent\sl
The wall to the left of the elevator on level~8 completes the exhibit
by illustrating a brand-new kind of knight's tour, not previously studied:
A set of {\it nested frames}, each only three cells wide. Here we see a
$7\times7$ frame inside a $31\times31$ frame inside a $55\times55$ frame. Each
larger frame is obtained from the next-smaller one by inserting four of the
modules that were used in the frieze on level~4. For several days I feared that
such tours would be impossible; but suddenly everything clicked into place.
\smallskip}
\noindent
크누스의 말을 토대로 그의 겹친 액자 {\it 그 자체\/}를 되살려보자. 세 액자는 저마다 폭 3칸 사각
테두리를 한 붓에 도는 {\it 진짜 닫힌 나이트 투어\/}이고, 나중에 우리의 프로그램이 그것을 확인한다.

나는 먼저 크누스의 세 투어를 그의 \pdfURL{{\it 그림}}{https://cs.stanford.edu/\TILDE/knuth/KTf.jpg}%
에서 간선 단위로 읽어 냈다. 읽어 낸 투어를 나이트 이동 열로 적어 |tours|에 담고, 되짚어 이어
칸으로 펼친 뒤, {\it 모든 칸이 꼭 한 번씩\/} 나오고 마지막 이동이 출발 칸으로
돌아오는 하나의 닫힌 고리임을 검증한다. 그리고 세 투어가 크누스의 말대로
{\it 마디를 끼워 넣어\/} 자라는지, 변마다 놓인 마디 수로 확인한다. 끝으로 세 투어를
한 중심에 겹쳐 \.{ktf.mp}에 그렸다. 마지막에 그 아름다움을 감상할 수 있을 것이다.

@c
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"strings"
)

@<타입 정의와 변수들@>
@<보조 루틴들@>

func main() {
	@<세 투어를 검증하고 재귀를 보인다@>
	@<크누스가 적어 둔 모티프와 대조한다@>
	@<구성법으로 되지어 대조한다@>
	@<겹친 액자 \.{ktf.mp}를 쓴다@>
}

@* 크누스의 세 나이트 투어. 칸은 $(r,c)$로 적되, 세 액자를 한 중심에 겹치기 좋도록 {\it 두 배\/}
좌표를 쓴다(중심이 원점, 칸은 짝수 자리). 그래서 나이트 한 걸음은 |km|의 방향을 두
배 한 것이다.
@<타입...@>=
type cell = [2]int
type edge = [2]cell

var km = [8]cell{
	{1, 2}, {2, 1}, {-1, 2}, {-2, 1}, {1, -2}, {2, -1}, {-1, -2}, {-2, -1},
}

@ 함수 |canon|은 이음을 한 방향으로 정규화해 중복을 없앤다.
@<보조...@>=
func canon(a, b cell) edge {
	if a[0] > b[0] || (a[0] == b[0] && a[1] > b[1]) {
		return edge{b, a}
	}
	return edge{a, b}
}

@ 크누스의 세 투어를 살펴보자. 투어 하나는 출발 칸과 이동 열로 적는다. 이동 열의 글자 하나는
|km|의 방향 번호($0$--$7$)이니, 한 액자를 도는 나이트의 발자국을 그대로 옮긴 것이다.
좌표는 두 배라 각 이동은 |km|의 두 배만큼 나아간다. 세 문자열은 각각 $48$, $336$,
$624$걸음으로, 폭 3칸 테두리의 칸 수($12N-36$)와 정확히 맞는다.
@<타입...@>=
type tour struct {
	start cell
	moves string
}

var tours = []tour{
	{cell{-6, -6}, "" +
		"040573030550737575700346415212657520262750564737"},
	{cell{-30, -30}, "" +
		"1515251515504040751512202003131340202070036336262613" +
		"7373437373140551515251515704040464625757566464616464" +
		"3130031313402020702020475664646164646257574334373731" +
		"6262633737720204313130020207020256464665757526464616" +
		"6131300202070202043131315157040405515152515163737336" +
		"2626137373433656657575264646164646504075151525151550" +
		"413737343737316262633626"},
	{cell{-54, -54}, "" +
		"0405504040751515251515504040751515251515726337373437" +
		"3731626263373734373731626302020702020431313002020702" +
		"0204313130030552515157040405515152515157040405515150" +
		"7373437373362626137373437373362626137375757526464616" +
		"4646657575264646164646657570070202043131300202070202" +
		"0431313002020346461646466575752646461646466575752646" +
		"4115155040407515152515155040407515152552131340202070" +
		"2020031313402020702020031264646164646257575664646164" +
		"6462575756657520207020200313134020207020200313134020" +
		"2626261373734373733626261373734373733627515152515157" +
		"0404055151525151570404055056616464625757566464616464" +
		"6257575664644737316262633737343737316262633737343737"},
}

@ 투어를 잇고 검증한다. 이동 열을 되짚어 칸의 고리로 펼친다. 두 배 좌표라 걸음마다
|km|의 두 배를 더한다.
@<보조...@>=
func (t tour) cells() []cell {
	cs := make([]cell, len(t.moves))
	c := t.start
	for i := 0; i < len(t.moves); i++ {
		cs[i] = c
		m := km[t.moves[i]-'0']
		c = cell{c[0] + 2*m[0], c[1] + 2*m[1]}
	}
	return cs
}

@ 이음(간선)은 고리에서 잇닿은 두 칸의 쌍이다.
@<보조...@>=
func (t tour) edges() []edge {
	cs := t.cells()
	es := make([]edge, len(cs))
	for i := range cs {
		es[i] = canon(cs[i], cs[(i+1)%len(cs)])
	}
	return es
}

@ 검증은 두 가지를 본다: 모든 칸이 서로 다른지(해밀턴)와 마지막 걸음이 출발 칸으로
닫히는지. 걸음마다 나이트 거리인 것은 이동 열을 |km|으로 지었으니 절로 참이다. 둘이 다
참이면 {\it 하나의 닫힌 나이트 투어\/}다.
@<보조...@>=
func (t tour) verify() (int, bool) {
	cs := t.cells()
	seen := map[cell]bool{}
	for _, c := range cs {
		if seen[c] {
			return len(cs), false
		}
		seen[c] = true
	}
	last := cs[len(cs)-1]
	m := km[t.moves[len(t.moves)-1]-'0']
	return len(cs), cell{last[0] + 2*m[0], last[1] + 2*m[1]} == t.start
}

@ 그림 \.{KTf.jpg}에서 읽어 낸 주기가 6인 실제 별무늬 한 마디다.
위쪽 변의 띠 좌표(행 $0,1,2$)로 적었고, 한 마디는
여섯 칸 주기로 열여덟 개의 이음을 갖는다. 이 마디로 세 투어의 재귀를 확인한다.

@ 이 마디가 어디서 온 것인지는 크누스가 밝혀 두었다. 겹친 액자를 두고 그는 ``the modules
that were used in the frieze on level~4''를 끼워 넣어 자란다고 했는데, 바로 그 level~4
프리즈의 모티프를 전시장 안내글의 {\it 다른 층\/} 대목---\.{Level 3: Long and skinny
tours}---에서 이렇게 적어 두었다:
\smallskip
{\narrower\noindent\sl One can verify that, on level~4, $2n$ copies of the motif
`011-223-110-212-131-222' will give a $3\times(12n+14)$ cycle.\smallskip}
\noindent
묶음이 여섯이니 $3\times6$ 블록, 곧 칸 열여덟이다. 닫힌 투어는 칸마다 이음이 둘이라 한
주기의 이음 수가 곧 칸 수이니, 우리가 그림에서 읽어 낸 이음 {\it 열여덟\/}과 맞아떨어진다.
$2n$개를 이어 $12n+14$가 되는 것도 여섯 칸짜리 모티프와 앞뒤가 맞는다.

@ 표기법은 그의 책 {\it Selected Papers on Fun and Games\/} 42장 {\sl Long and Skinny
Knight's Tours\/}에 있다. 안내글에는 정의가 없어 한동안 풀지 못했는데, 그 장을 얻어
읽으니 규칙이 또렷했다. 그래서 이제 그림의 픽셀이 아니라 {\it 그가 손수 적은 문자열\/}로
|knuthMod|를 재어 볼 수 있게 되었다. 덧붙이자면 level~8에도 프리즈가 따로 있고(모티프
`133-122-011-023-131-110-231-223-001-101', $3\times(10n+20)$ 고리) 그것은 엘리베이터
{\it 문 위\/}에 있으니, {\it 왼쪽 벽\/}의 겹친 액자와 헷갈리지 말 일이다.

@<타입...@>=
var knuthMod = []edge{
	{{0, 0}, {1, 2}}, {{1, 0}, {2, 2}}, {{0, 1}, {1, 3}}, {{1, 1}, {0, 3}},
	{{2, 1}, {1, 3}}, {{2, 1}, {0, 2}}, {{0, 2}, {2, 3}}, {{1, 2}, {2, 4}},
	{{2, 2}, {1, 4}}, {{0, 3}, {1, 5}}, {{2, 3}, {0, 4}}, {{0, 4}, {2, 5}},
	{{1, 4}, {2, 6}}, {{2, 4}, {1, 6}}, {{0, 5}, {1, 7}}, {{0, 5}, {2, 6}},
	{{1, 5}, {0, 7}}, {{2, 5}, {0, 6}},
}

@ 재귀를 확인해보자. 투어를 판 좌표$[0,N)$의 이음 집합으로 옮긴 뒤(두 배 좌표를 도로
반으로 접는다), 위쪽 변을 훑어 |knuthMod| 한 마디가 통째로 놓인 열 위치를 센다.
크누스의 말대로라면 큰 액자일수록 변마다 마디가 더 많아야 한다.
@<보조...@>=
func edgeSet(t tour, N int) map[edge]bool {
	m := map[edge]bool{}
	h := N - 1
	for _, e := range t.edges() {
		a := cell{(e[0][0] + h) / 2, (e[0][1] + h) / 2}
		b := cell{(e[1][0] + h) / 2, (e[1][1] + h) / 2}
		m[canon(a, b)] = true
	}
	return m
}

@ 위쪽 변에 마디가 통째로 놓인 열 오프셋의 개수가 곧 ``변마다 마디 수''다.
@<보조...@>=
func modulesPerSide(es map[edge]bool, N int) int {
	count := 0
	for off := -4; off < N; off++ {
		full := true
		for _, e := range knuthMod {
			a := cell{e[0][0], e[0][1] + off}
			b := cell{e[1][0], e[1][1] + off}
			if !es[canon(a, b)] {
				full = false
				break
			}
		}
		if full {
			count++
		}
	}
	return count
}

@ 액자 크기 $N$은 칸 수에서 거꾸로 얻는다
($12N-36$개이므로 $N=(\hbox{칸}+36)/12$). 각 투어가 하나의 닫힌 투어임을 확인하고,
변마다 놓인 마디 수를 함께 찍는다.
@<세 투어를 검증하고 재귀를 보인다@>=
for _, t := range tours {
	n, ok := t.verify()
	if !ok {
		log.Fatalf("투어가 닫힌 나이트 투어가 아니다 (칸 %d개)", n)
	}
	N := (n + 36) / 12
	k := modulesPerSide(edgeSet(t, N), N)
	fmt.Printf("%2d×%-2d 액자: 칸 %3d개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 %d개\n",
		N, N, n, k)
}

@* 크누스가 적어 둔 모티프를 푼다. 42장은 $3\times n$ 투어를 {\it 열 단위로 이어 붙이는
상태 기계\/}로 본다. 열을 하나 더 붙일 때, 새 열의 세 칸 $(0,j)\cdot(1,j)\cdot(2,j)$로
어떤 이음이 들어오는지를 세 자리 수 {\it abc\/}로 적는다. 자리마다 값이 더해진다
(p.\thinspace514):
\smallskip
{\narrower\noindent
{\it a\/}: $+1$은 $(1,j\!-\!2)$--$(0,j)$, $+2$는 $(2,j\!-\!1)$--$(0,j)$\par
{\it b\/}: $+1$은 $(0,j\!-\!2)$--$(1,j)$, $+2$는 $(2,j\!-\!2)$--$(1,j)$\par
{\it c\/}: $+1$은 $(0,j\!-\!1)$--$(2,j)$, $+2$는 $(1,j\!-\!2)$--$(2,j)$\par}
\smallskip
\noindent
나이트가 새 열로 들어오는 길은 이 여섯뿐이니 빠짐이 없다. ($+4$는 열린 투어의 양 끝을
다루는 가상 꼭짓점 $\infty$로 가는 이음인데, 닫힌 투어에는 나오지 않는다.)

@ 규칙을 표로 적는다. |codeRules[pos][bit]|은 새 열의 |pos|행으로 들어오는 이음의
반대쪽 끝이 어느 행, 몇 열 뒤인지다.
@<타입...@>=
var codeRules = [3][2]cell{
	{{1, -2}, {2, -1}},
	{{0, -2}, {2, -2}},
	{{0, -1}, {1, -2}},
}

var knuthMotif = "011-223-110-212-131-222" // level 4 프리즈 (42장 p.514의 표기)

@ 모티프를 |reps|번 되풀이해 이음으로 편다. 마디 하나가 여섯 열이니 전이도 여섯이다.
@<보조...@>=
func motifEdges(motif string, reps int) map[edge]bool {
	es, j := map[edge]bool{}, 0
	for r := 0; r < reps; r++ {
		for _, g := range strings.Split(motif, "-") {
			@<전이 하나가 더하는 이음을 담는다@>
			j++
		}
	}
	return es
}

@ @<전이 하나가 더하는 이음을 담는다@>=
for pos := 0; pos < 3; pos++ {
	d := int(g[pos] - '0')
	for bit := 0; bit < 2; bit++ {
		if d&(1<<bit) != 0 {
			p := codeRules[pos][bit]
			es[canon(cell{p[0], j + p[1]}, cell{pos, j})] = true
		}
	}
}

@ 견줄 상대는 |knuthMod|를 여섯 열씩 밀어 깐 무늬다. 열 위상이 어디서 시작하느냐는
서로 다를 수 있으니, 가운데 창만 잘라 견주고 이동은 찾아본다.
@<보조...@>=
func tileMod(reps int) map[edge]bool {
	es := map[edge]bool{}
	for t := 0; t < reps; t++ {
		for _, e := range knuthMod {
			es[canon(cell{e[0][0], e[0][1] + 6*t}, cell{e[1][0], e[1][1] + 6*t})] = true
		}
	}
	return es
}

@ @<보조...@>=
func window(es map[edge]bool, lo, hi, shift int) map[edge]bool {
	out := map[edge]bool{}
	for e := range es {
		a := cell{e[0][0], e[0][1] + shift}
		b := cell{e[1][0], e[1][1] + shift}
		if a[1] >= lo && a[1] < hi && b[1] >= lo && b[1] < hi {
			out[canon(a, b)] = true
		}
	}
	return out
}

@ 이제 대조한다. 두 무늬가 열 이동 하나로 포개지면, 우리가 그림에서 읽어 낸 마디가
크누스가 손수 적은 그것과 같다는 뜻이다.
@<크누스가 적어 둔 모티프와 대조한다@>=
mine := window(tileMod(14), 20, 56, 0)
theirs := motifEdges(knuthMotif, 14)
matched := false
for s := -40; s <= 40 && !matched; s++ {
	matched = same(window(theirs, 20, 56, s), mine)
}
if !matched {
	log.Fatal("크누스가 적어 둔 모티프가 knuthMod와 다른 무늬다")
}
fmt.Printf("모티프 대조: %s가 knuthMod와 같은 무늬 ✓ (창 안의 이음 %d개)\n",
	knuthMotif, len(mine))

@* 구성법으로 다시 만들어 대조한다. 이웃한 \.{frame} 프로그램은 크누스의 무늬로 {\it 새로운
크기\/}의 액자를 짓는다. 그 구성법은 이렇다---네 변에 마디를 여섯 칸씩 이어 깔고, 네
모서리에 매듭을 얹는다. 그 매듭이 넷 다 같지 않다는 것이 요령의 핵심이다.

여기서는 그 구성법이 정말 크누스의 것을 되살리는지 {\it 이 프로그램 안에서\/}
확인한다. 위에서 읽어 낸 크누스의 투어를 근거로 삼아, 마디를 걷어 낸 나머지에서 모서리
매듭을 {\it 직접 뽑아내고\/}, 그것으로 액자를 되지어 원본과 견준다. 그러니 어느 한쪽이
틀어지면 빌드가 멈춘다.

@ 판 좌표에서 쓰는 잔심부름들이다. |isBorder|는 폭 3칸 테두리의 칸을 가리고, |put|은
두 끝이 다 테두리일 때만 이음을 받는다. |xforms|는 위쪽 변을 나머지 세 변으로 옮기는
$90^\circ$ 회전 넷이다.
@<보조...@>=
func isBorder(c cell, N int) bool {
	r, cc := c[0], c[1]
	return r >= 0 && r < N && cc >= 0 && cc < N &&
		(r < 3 || r > N-4 || cc < 3 || cc > N-4)
}

func put(es map[edge]bool, N int, a, b cell) {
	if isBorder(a, N) && isBorder(b, N) {
		es[canon(a, b)] = true
	}
}

@ @<보조...@>=
func xforms(N int) []func(r, c int) cell {
	return []func(r, c int) cell{
		func(r, c int) cell { return cell{r, c} },
		func(r, c int) cell { return cell{c, N - 1 - r} },
		func(r, c int) cell { return cell{N - 1 - r, N - 1 - c} },
		func(r, c int) cell { return cell{N - 1 - c, r} },
	}
}

@ 네 변에 마디를 깐다. 오프셋 $5,11,\ldots$로 이어 깔되 모서리는 매듭에 내준다.
@<보조...@>=
func sideMods(N int) map[edge]bool {
	es := map[edge]bool{}
	for _, f := range xforms(N) {
		for off := 5; off <= N-13; off += 6 {
			for _, e := range knuthMod {
				put(es, N, f(e[0][0], e[0][1]+off), f(e[1][0], e[1][1]+off))
			}
		}
	}
	return es
}

@ 이제 매듭을 뽑는다. 크누스의 이음에서 마디를 걷어 내면 남는 것이 모서리 매듭이다.
남은 이음을 가까운 모서리별로 가르고, 그 모서리를 원점으로 하는 좌표로 되돌린다
(|xforms|의 역변환이다). 늘 같은 차례로 나오도록 정렬해 둔다.
@<보조...@>=
func cornerKnots(t tour, N int) [4][]edge {
	rest := edgeSet(t, N)
	for e := range sideMods(N) {
		delete(rest, e)
	}
	h := N - 1
	inv := []func(r, c int) cell{
		func(r, c int) cell { return cell{r, c} },
		func(r, c int) cell { return cell{h - c, r} },
		func(r, c int) cell { return cell{h - r, h - c} },
		func(r, c int) cell { return cell{c, h - r} },
	}
	var out [4][]edge
	@<남은 이음을 모서리별로 갈라 담는다@>
	return out
}

@ 이음의 두 끝이 다 위쪽 절반이면 위, 다 왼쪽 절반이면 왼쪽---그렇게 네 모서리를 가른다.
@<남은 이음을 모서리별로 갈라 담는다@>=
for e := range rest {
	top := e[0][0] <= N/2 && e[1][0] <= N/2
	left := e[0][1] <= N/2 && e[1][1] <= N/2
	q := 2
	switch {
	case top && left:
		q = 0
	case top:
		q = 1
	case left:
		q = 3
	}
	f := inv[q]
	out[q] = append(out[q], canon(f(e[0][0], e[0][1]), f(e[1][0], e[1][1])))
}
for q := range out {
	sort.Slice(out[q], func(i, j int) bool { return lessE(out[q][i], out[q][j]) })
}

@ |lessE|는 이음을 한 줄로 세운다. |same|은 두 이음 집합이 같은지 본다.
@<보조...@>=
func lessE(x, y edge) bool {
	if x[0] != y[0] {
		return x[0][0] < y[0][0] || (x[0][0] == y[0][0] && x[0][1] < y[0][1])
	}
	return x[1][0] < y[1][0] || (x[1][0] == y[1][0] && x[1][1] < y[1][1])
}

func same(a, b map[edge]bool) bool {
	if len(a) != len(b) {
		return false
	}
	for e := range a {
		if !b[e] {
			return false
		}
	}
	return true
}

@ 뽑아낸 매듭으로 액자를 되짓는다. 마디를 깔고 네 모서리에 매듭을 제자리로 옮겨 얹으면
그만이다---2-opt 같은 뒷손질은 없다.
@<보조...@>=
func rebuild(N int, kn [4][]edge) map[edge]bool {
	es := sideMods(N)
	for q, f := range xforms(N) {
		for _, e := range kn[q] {
			put(es, N, f(e[0][0], e[0][1]), f(e[1][0], e[1][1]))
		}
	}
	return es
}

@ 재료를 한 줄의 수로 줄인 것이 {\it 지문\/}이다(FNV-1a). 마디와 매듭 넷을 모두 넣어
찍으므로 재료 전부를 덮는다. \.{frame} 쪽도 제가 지닌 |knuthMod|과 |knuthCorners|의
지문을 같은 방식으로 찍으니, 둘을 견주면 두 프로그램이 같은 재료를 쓰고 있는지 한눈에
안다.
@<보조...@>=
func fingerprint(mod []edge, kn [4][]edge) uint32 {
	h := uint32(2166136261)
	for _, es := range append([][]edge{mod}, kn[:]...) {
		sorted := append([]edge(nil), es...)
		sort.Slice(sorted, func(i, j int) bool { return lessE(sorted[i], sorted[j]) })
		for _, e := range sorted {
			for _, v := range []int{e[0][0], e[0][1], e[1][0], e[1][1]} {
				h = (h ^ uint32(v)) * 16777619
			}
		}
	}
	return h
}

@ $31$과 $55$에서 뽑은 매듭이 같은지 보고(크기와 무관한 재료라는 뜻이다), 그것으로
되지은 액자가 크누스의 것과 이음 하나까지 같은지 본다. $7\times7$이 빠진 까닭은 곧이어
따로 밝힌다.
@<구성법으로 되지어 대조한다@>=
kn31, kn55 := cornerKnots(tours[1], 31), cornerKnots(tours[2], 55)
if fingerprint(knuthMod, kn31) != fingerprint(knuthMod, kn55) {
	log.Fatal("31과 55에서 뽑은 모서리 매듭이 서로 다르다")
}
@<되지은 액자를 원본과 견준다@>
fmt.Printf("구성법 대조: 31·55의 모서리 매듭이 같고, 되지은 액자가 원본과 일치 ✓\n")
fmt.Printf("재료 지문: %08x (frame이 찍는 것과 같아야 한다)\n",
	fingerprint(knuthMod, kn55))
@<7×7은 왜 이 구성법으로 안 되는지 재어 본다@>

@ 그런데 왜 $7\times7$만 이동 열로 적을 수밖에 없는가? {\it 재료가 모자라서가 아니다\/}.
매듭 넷을 $7\times7$ 판에 그대로 얹어 보면 판 안에 이음이 일흔 개나 남는데, 정작 필요한
것은 마흔여덟 개다. 게다가 크누스의 마흔여덟 개는 그 일흔 개 안에 {\it 하나도 빠짐없이\/}
들어 있다. 모자란 게 아니라 스물두 개가 남아돈다.

까닭은 매듭끼리 포개져서다. 매듭 하나는 모서리에서 세로로 여덟 줄, 가로로 일곱 칸을
차지한다. 그러니 한 변에는 한 매듭의 가로팔(일곱 칸)과 이웃 매듭의 세로팔(여덟 칸)이
나란히 놓여, 각각 $0\ldots6$열과 $N-8\ldots N-1$열을 차지한다. $N=31$이면 둘 사이가
벌어져 그 틈을 마디가 메우고, $N=13$이면 두 칸($5,6$열)이 겹쳐 서로 맞물린다---여기까지가
성한 겹침이다. 그런데 $N=7$이면 뒤엣것이 $-1$열에서 시작해야 한다. 판 밖이다.

두 매듭이 포개지면 칸마다 이음이 둘을 넘어 버리고, 남아도는 스물두 개 중 어느 것을
덜어 내야 하는지는 구성법이 말해 주지 않는다.

@ ``말해 주지 않는다''는 것을 좀 더 밀어붙여 보자. 쌓인 일흔 개 안에서 {\it 모든 칸이
차수 $2$인\/} 부분집합을 남김없이 세어 보면 열아홉 가지가 나오고, 그중 고리가 하나뿐인
것---곧 진짜 닫힌 투어---은 {\it 일곱 가지\/}다. 크누스의 $7\times7$은 그 일곱 중
하나일 뿐이다. 나머지 여섯도 똑같이 멀쩡한 닫힌 투어여서, 구성법만으로는 어느 것이
그의 것인지 가릴 길이 없다.

@ 그러니 $7\times7$은 이 구성법의 {\it 산물\/}이 아니라 {\it 그것이 자라 나온 바탕\/}
이다. 크누스가 ``네 마디를 끼워 넣어'' 다음 액자를 얻는다고 한 바로 그 출발점이니,
여기서는 그의 이동 열로 적어 두는 수밖에 없다(``일곱 중 몇째''라고 적으면 짧기야 하겠지만,
그 번호는 세는 차례에 딸린 값이라 근거가 되지 못한다). \.{frame}이 $n\ge13$을 요구하는
것도 똑같은 까닭이다.

@ 위의 일흔과 마흔여덟을 말로만 두지 않고 재어 둔다. 셈이 어긋나면 그 자리에서 멈춘다.
@<7×7은 왜 이 구성법으로 안 되는지 재어 본다@>=
piled := map[edge]bool{}
for q, f := range xforms(7) {
	for _, e := range kn55[q] {
		put(piled, 7, f(e[0][0], e[0][1]), f(e[1][0], e[1][1]))
	}
}
@<겹쳐 쌓인 것이 크누스의 7×7을 품는지 본다@>

@ @<겹쳐 쌓인 것이 크누스의 7×7을 품는지 본다@>=
k7 := edgeSet(tours[0], 7)
for e := range k7 {
	if !piled[e] {
		log.Fatal("7×7의 이음이 매듭 넷 밖에 있다")
	}
}
if len(piled) <= len(k7) {
	log.Fatal("7×7에서 매듭이 포개지지 않았다")
}
fmt.Printf("7×7은 구성법 밖: 매듭 넷을 얹으면 이음 %d개가 쌓인다 (필요한 것은 %d개, "+
	"크누스의 것은 모두 그 안에 있다)\n", len(piled), len(k7))
@<쌓인 것 안에 닫힌 투어가 몇이나 숨어 있는지 센다@>

@ 크누스의 것이 그 일곱에 들어 있는지도 함께 본다. 하나뿐이라면 이동 열이 없어도
$7\times7$이 정해지겠지만, 일곱이니 그렇지 않다.
@<쌓인 것 안에 닫힌 투어가 몇이나 숨어 있는지 센다@>=
all, single := twoFactors(sortEdges(piled))
if single < 2 {
	log.Fatal("7×7 후보가 하나뿐이라면 이동 열 없이도 정해진다")
}
fmt.Printf("7×7 후보: 차수 2인 부분집합 %d가지, 그중 닫힌 투어 %d가지"+
	" — 크누스의 것은 그중 하나일 뿐이다\n", all, single)

@ |twoFactors|는 이음 목록 안에서 모든 칸이 차수 $2$가 되는 부분집합을 남김없이 세고,
그중 고리가 하나인 것도 따로 센다. 칸을 차례로 훑으며 그 칸에 붙은 아직 안 정한 이음
가운데 몇을 고를지 되짚어 본다.
@<보조...@>=
func twoFactors(es []edge) (all, single int) {
	cs := cellsOf(es)
	inc := map[cell][]int{}
	for i, e := range es {
		inc[e[0]] = append(inc[e[0]], i)
		inc[e[1]] = append(inc[e[1]], i)
	}
	st, deg := make([]int, len(es)), map[cell]int{}
	var rec func(int)
	@<칸 하나를 정하고 다음으로 넘어간다@>
	rec(0)
	return
}

@ @<칸 하나를 정하고 다음으로 넘어간다@>=
rec = func(ci int) {
	if ci == len(cs) {
		all++
		if loopCount(es, st) == 1 {
			single++
		}
		return
	}
	var free []int
	for _, i := range inc[cs[ci]] {
		if st[i] == 0 {
			free = append(free, i)
		}
	}
	need := 2 - deg[cs[ci]]
	if need < 0 || need > len(free) {
		return
	}
	@<자유 이음 가운데 need개를 고르는 모든 길을 따라간다@>
}

@ 부분집합은 비트로 훑는다. 고른 이음의 반대쪽 끝이 차수 $2$를 넘으면 그 길은 접는다.
@<자유 이음 가운데 need개를 고르는 모든 길을 따라간다@>=
for mask := 0; mask < 1<<len(free); mask++ {
	n := 0
	for k := range free {
		n += mask >> k & 1
	}
	if n != need {
		continue
	}
	bad := false
	for k, i := range free {
		if mask>>k&1 == 1 {
			st[i] = 1
			deg[es[i][0]]++
			deg[es[i][1]]++
			if deg[es[i][0]] > 2 || deg[es[i][1]] > 2 {
				bad = true
			}
		} else {
			st[i] = -1
		}
	}
	if !bad {
		rec(ci + 1)
	}
	@<고른 것을 도로 물린다@>
}

@ @<고른 것을 도로 물린다@>=
for k, i := range free {
	if mask>>k&1 == 1 {
		deg[es[i][0]]--
		deg[es[i][1]]--
	}
	st[i] = 0
}

@ |cellsOf|는 이음에 나온 칸을 차례대로 늘어놓고, |loopCount|는 고른 이음들이 이루는
고리 수를 센다.
@<보조...@>=
func cellsOf(es []edge) []cell {
	seen := map[cell]bool{}
	var out []cell
	for _, e := range es {
		for _, p := range e {
			if !seen[p] {
				seen[p] = true
				out = append(out, p)
			}
		}
	}
	sort.Slice(out, func(i, j int) bool {
		return out[i][0] < out[j][0] ||
			(out[i][0] == out[j][0] && out[i][1] < out[j][1])
	})
	return out
}

@ @<보조...@>=
func loopCount(es []edge, st []int) int {
	sel := map[edge]bool{}
	for i, s := range st {
		if s == 1 {
			sel[es[i]] = true
		}
	}
	_, n := loopID(sel)
	return n
}

@ |sortEdges|는 맵을 한 줄로 세운다. 훑는 차례가 늘 같아야 세는 값도 늘 같다.
@<보조...@>=
func sortEdges(es map[edge]bool) []edge {
	out := make([]edge, 0, len(es))
	for e := range es {
		out = append(out, e)
	}
	sort.Slice(out, func(i, j int) bool { return lessE(out[i], out[j]) })
	return out
}

@ |loopID|는 고른 이음들이 이루는 고리에 번호를 매기고 그 수를 돌려준다. 차수가 $2$가
아닌 칸이 있으면 걸음이 막히므로 $-1$로 알린다.
@<보조...@>=
func loopID(es map[edge]bool) (map[cell]int, int) {
	adj := map[cell][]cell{}
	for e := range es {
		adj[e[0]] = append(adj[e[0]], e[1])
		adj[e[1]] = append(adj[e[1]], e[0])
	}
	for _, v := range adj {
		if len(v) != 2 {
			return nil, -1
		}
	}
	id, n := map[cell]int{}, 0
	@<고리를 따라 걸으며 번호를 칠한다@>
	return id, n
}

@ @<고리를 따라 걸으며 번호를 칠한다@>=
for s := range adj {
	if _, ok := id[s]; ok {
		continue
	}
	prev, cur := cell{-1, -1}, s
	for {
		id[cur] = n
		nx := adj[cur][0]
		if nx == prev {
			nx = adj[cur][1]
		}
		prev, cur = cur, nx
		if cur == s {
			break
		}
	}
	n++
}

@ @<되지은 액자를 원본과 견준다@>=
for _, x := range []struct {
	N int
	t tour
}{{31, tours[1]}, {55, tours[2]}} {
	if !same(rebuild(x.N, kn55), edgeSet(x.t, x.N)) {
		log.Fatalf("%d×%d를 구성법으로 되지었더니 크누스의 것과 다르다", x.N, x.N)
	}
}

@* 겹친 액자를 그린다. 세 투어는 모두 한 중심(원점)에 놓인 두 배 좌표라, 그대로
겹쳐 그리면 $7$이 $31$ 안에, $31$이 $55$ 안에 든다. 바깥부터 붉게$\cdot$푸르게
$\cdot$초록으로 칠해 겹을 구분한다. 그림은 {\logo METAPOST}로 그린다.
@<겹친 액자...@>=
out, err := os.Create("ktf.mp")
if err != nil {
	log.Fatal(err)
}
w := bufio.NewWriter(out)
fmt.Fprintln(w, `% ktf.mp — 크누스의 겹친 나이트 투어 액자 (ktf.go가 씀).`)
fmt.Fprintln(w, "beginfig(1);")
for i := len(tours) - 1; i >= 0; i-- {
	@<투어 하나를 그린다@>
}
fmt.Fprintln(w, "drawoptions();")
fmt.Fprintln(w, "endfig;")
fmt.Fprintln(w, "end.")
w.Flush()
out.Close()
fmt.Println("겹친 액자 ktf.mp를 썼다 (7·31·55, 진짜 닫힌 투어 셋).")

@ 겹의 색은 |tours|와 같은 순서로 적는다---안쪽 $7$이 초록, $31$이 푸름, 바깥 $55$가
붉음이다. 바깥부터 그리므로 종이에는 붉은 것이 먼저 깔리고 그 안에 푸름과 초록이 얹힌다.
@<타입...@>=
var colors = []string{"0.5green", "0.65blue", "0.8red"}

@ 두 배 좌표를 그대로 점으로 삼고, 판의 위가 위로 오도록 $y$를 뒤집는다. 단위는
$1.9\,$pt라 가장 큰 $55$ 액자(폭 $108$)가 $9\,$cm쯤 된다. 펜과 색은 투어마다
|drawoptions|로 {\it 한 번만\/} 지정하니, |draw| 줄에는 경로만 남는다.
@<투어 하나를 그린다@>=
const u = 1.9
fmt.Fprintf(w, "drawoptions(withpen pencircle scaled .7pt withcolor %s);\n", colors[i])
for _, e := range tours[i].edges() {
	fmt.Fprintf(w, "draw (%.1f,%.1f)--(%.1f,%.1f);\n",
		float64(e[0][1])*u, -float64(e[0][0])*u,
		float64(e[1][1])*u, -float64(e[1][0])*u)
}

@ 그려 놓고 보면 크누스의 \.{KTf.jpg}와 똑같이, 폭 3칸 액자 셋이 이 빠진 곳 없이 서로를
감싼다---저마다 한 붓에 그린 닫힌 나이트 투어다.
\medskip
\centerline{\pic height 9cm{ktf-1.pdf}}

@ 프로그램이 표준 출력에 찍는 것은 이렇다.
\medskip
\begingroup
\verbatim
 7×7  액자: 칸  48개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 0개
31×31 액자: 칸 336개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 3개
55×55 액자: 칸 624개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 7개
모티프 대조: 011-223-110-212-131-222가 knuthMod와 같은 무늬 ✓ (창 안의 이음 102개)
구성법 대조: 31·55의 모서리 매듭이 같고, 되지은 액자가 원본과 일치 ✓
재료 지문: 74dc9931 (frame이 찍는 것과 같아야 한다)
7×7은 구성법 밖: 매듭 넷을 얹으면 이음 70개가 쌓인다 (필요한 것은 48개, 크누스의 것은 모두 그 안에 있다)
7×7 후보: 차수 2인 부분집합 19가지, 그중 닫힌 투어 7가지 — 크누스의 것은 그중 하나일 뿐이다
겹친 액자 ktf.mp를 썼다 (7·31·55, 진짜 닫힌 투어 셋).
!endgroup
\endgroup
\medskip
\noindent
크누스의 말($7\to31\to55$, 변마다 마디를 더 끼워 넣는다)이 되살린 투어에서 그대로
드러난다: $31$ 액자는 변마다 마디 셋, $55$ 액자는 일곱---한 단계에 변마다 넷씩
늘었다. 가장 작은 $7$ 액자는 마디가 통째로 들어설 자리가 없어, 네 모서리가 바로 맞물린
바탕꼴이다.

@ 변의 길이만 보아도 같은 말이 나온다. $7\to31$도 $31\to55$도 변이 꼭
$24$칸씩 늘었는데, 이는 여섯 칸짜리 마디 {\it 넷\/}이다---그가 ``inserting {\it four\/}
of the modules''라 한 그대로다. 그러니 마디 수가 $0\to3\to7$로 나온 것에서 뒤의
$+4$가 바로 그 넷이고, 앞의 $+3$은 $7$ 액자에 온전한 마디가 하나도 들어서지 못해
생긴 셈법의 어긋남일 뿐이다.

@* 색인.
