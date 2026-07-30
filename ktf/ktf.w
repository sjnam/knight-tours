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
  \moveleft.63in\hbox{\pic width 7.55in height 11.05in{myframe.pdf}}\vss}%
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
%    \moveleft.55in\hbox{\pic width 7.55in height 10.65in{frames-1.pdf}}\vss}%
%  \vskip.6in \centerline{\titlefont\Gtitle}\vskip.7in\vfill}

\font\logo=logo10
\def\title{Knight's Frames}

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
)

@<타입 정의와 변수들@>
@<보조 루틴들@>

func main() {
	@<세 투어를 검증하고 재귀를 보인다@>
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
fmt.Fprintln(w, "endfig;")
fmt.Fprintln(w, "end.")
w.Flush()
out.Close()
fmt.Println("겹친 액자 ktf.mp를 썼다 (7·31·55, 진짜 닫힌 투어 셋).")

@ 두 배 좌표를 그대로 점으로 삼고, 판의 위가 위로 오도록 $y$를 뒤집는다. 단위는
$1.9\,$pt라 가장 큰 $55$ 액자(폭 $108$)가 $9\,$cm쯤 된다.
@<투어 하나를 그린다@>=
const u = 1.9
for _, e := range tours[i].edges() {
	fmt.Fprintf(w, "draw (%.1f,%.1f)--(%.1f,%.1f) withpen pencircle scaled .7pt;\n",
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
겹친 액자 ktf.mp를 썼다 (7·31·55, 진짜 닫힌 투어 셋).
!endgroup
\endgroup
\medskip
\noindent
크누스의 말($7\to31\to55$, 변마다 마디를 더 끼워 넣는다)이 되살린 투어에서 그대로
드러난다: $31$ 액자는 변마다 마디 셋, $55$ 액자는 일곱---한 단계에 변마다 넷씩
늘었다. 가장 작은 $7$ 액자는 마디가 통째로 들어설 자리가 없어, 네 모서리가 바로 맞물린
바탕꼴이다.

@* 색인.
