% 이 데모는 Knuth의 나이트 투어 전시장 맨 마지막 그림(KTf)의 액자 무늬를 좇아,
% 폭 3칸 사각 테두리를 도는 진짜 닫힌 나이트 투어로 이 문서의 모든 페이지를 두른다.
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

@* 페이지를 두르는 나이트 투어 액자. 크누스의 \pdfURL{{\it 나이트 투어 전시장}}%
{https://cs.stanford.edu/\TILDE/knuth/knights.html}의 맨 마지막
그림은 폭이 딱 3칸인 사각 테두리를 나이트가 도는 투어를, 여섯 꼭짓점
별(육각성)이 촘촘히 맞물린 띠처럼 짜 넣은 겹친 액자다. 나는 이 무늬로 종이(A4)처럼
세로가 긴 직사각형 액자를 지어, 이 문서의 페이지를 두르는 배경으로 쓰려 한다.
그의 별무늬로 {\it 새로운 크기의 직사각\/} 액자를 짓되, 그것 역시 진짜
하나의 닫힌 투어가 되게 한다.

먼저 크누스의 무늬를 그의 \pdfURL{{\it 그림}}{https://cs.stanford.edu/\TILDE/knuth/KTf.jpg}%
에서 간선 단위로 읽어 냈다. 곧은 변에 칸
격자를 맞춘 뒤 나이트가 갈 수 있는 이음마다 흰 선이 그어져 있는지 픽셀을 훑으니,
{\it 모든 칸이 정확히 두 이음\/}을 갖는 깨끗한 투어가 나왔다. 무늬의 주기는 여섯 칸,
곧은 변의 한 마디는 열여덟 개의 이음(|knuthMod|)이고, 모서리를 도는 매듭은 서른 개의
이음이었다. 이 둘이 이 액자의 두 재료다.

처음에 나는 매듭을 {\it 하나\/}만 읽어 내 네 모서리에 돌려 놓았다. 그랬더니 모든 칸이
degree $2$가 되기는 해도 변마다 고리 하나씩 {\it 네 개의 닫힌 고리\/}로 갈려서, 이웃한
두 고리를 2-opt로 이어 붙여 하나로 꿰야 했다. 그런데 그렇게 지은 액자를 크누스의 것과
간선 단위로 견주어 보니 모서리가 서로 달랐다. 내 2-opt가 하필 모서리의 이음을 골라
바꿔치웠기 때문이다.

그래서 그의 투어에서 네 모서리를 {\it 따로따로\/} 읽어 내 보았다. 놀랍게도 넷이 같지
않았다---기본꼴 하나에, 이음 다섯이 다른 것과 둘이 다른 것, 그러니까 서로 다른 매듭
{\it 세 종류\/}를 그는 자리마다 골라 쓰고 있었다. 고리를 잇는 {\it 건너뜀이 매듭 안에
이미 들어 있는\/} 것이다. 그것이 그가 말한 ``everything clicked into place''의 정체다.
그래서 이 프로그램은 2-opt를 쓰지 않는다. 네 매듭을 어느 자리에 놓을지만 고르면
하나의 닫힌 투어가 저절로 나온다.

@ 구성이 $N_h,N_w$의 매개변수이므로, 같은 코드로 {\it 세로\/}(기본 $103\times73$)와
{\it 가로\/}(기본 $73\times103$) 두 방향을 다 짓는다(크기는 명령행에서 바꾼다).
나이트 이동은 $90^\circ$ 회전에 대해 불변이라 어느 쪽이든 진짜 닫힌 투어다.
둘을 \.{frame.mp}에 \.{beginfig(1)}(세로), \.{beginfig(2)}(가로)로 담으면
\.{mptopdf}가 \.{frame-1.pdf}, \.{frame-2.pdf}로 나눠 낸다. 세로짜리는 limbo에서
\.{\\plainoutput}이 이 문서의 {\it 모든 페이지\/} 바탕에 깔고, 가로짜리는 가로 판형의
{\it 다른 문서\/}에 갖다 쓴다.
% 여기서는 크누스의 그 무늬를 직사각으로 구부려 {\it 짓는다\/}.

@c
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
)

@<타입 정의와 변수 선언@>
@<보조 루틴들@>

func main() {
	@<액자 배경 \.{framedef.mp}를 쓴다@>
}

@* 기본 도구. 칸은 $(r,c)$로 적고, 이음(간선)은 두 칸의 쌍으로 적는다.
@<타입...@>=
type cell = [2]int
type edge = [2]cell

@ 함수 |canon|은 이음을 한 방향으로 정규화해 중복을 없애고, |lessE|는 이음을 한 줄로
세워 출력을 재현 가능하게 한다.
@<보조...@>=
func canon(a, b cell) edge {
	if a[0] > b[0] || (a[0] == b[0] && a[1] > b[1]) {
		return edge{b, a}
	}
	return edge{a, b}
}

func lessE(x, y edge) bool {
	if x[0] != y[0] {
		return x[0][0] < y[0][0] || (x[0][0] == y[0][0] && x[0][1] < y[0][1])
	}
	return x[1][0] < y[1][0] || (x[1][0] == y[1][0] && x[1][1] < y[1][1])
}

@ 폭 3칸 테두리의 칸을 |isBorder|가 가린다. 판 밖이거나 테두리가 아닌 칸으로 가는
이음은 받지 않는다.
@<보조...@>=
func isBorder(c cell, Nh, Nw int) bool {
	r, cc := c[0], c[1]
	return r >= 0 && r < Nh && cc >= 0 && cc < Nw &&
		(r < 3 || r > Nh-4 || cc < 3 || cc > Nw-4)
}

@ 이음 집합을 {\logo METAPOST} 선분들로 그린다. 펜(굵기 |pw|)과 선 색(|line|)은
|drawoptions|로 {\it 한 번만\/} 지정한다. {\logo METAPOST}의 |for|는 쉼표로 늘어놓은
값 목록을 그대로 돌 수 있으니, 배열도 인덱스도 없이 경로 목록을
|for q = 경로, 경로, ...: draw q; endfor|로 그린다---그래서 \.{frame.mp}에는 |draw|도
한 번, 첨자도 없이 경로 |()--()| 데이터만 남는다. 끝나면 |drawoptions()|로 되돌려
다음 그림에 새지 않게 한다. 판의 위쪽이 위로 오도록 $y$를 뒤집고, 중심을 원점에 맞춘다.
@<보조...@>=
func drawEdges(w *bufio.Writer, es []edge, Nh, Nw int, u float64) {
	offx := float64(Nw-1) / 2
	offy := float64(Nh-1) / 2
	px := func(c cell) float64 { return (float64(c[1]) - offx) * u }
	py := func(c cell) float64 { return -(float64(c[0]) - offy) * u }
	fmt.Fprintln(w, "drawoptions(withpen pencircle scaled pw withcolor line);")
	fmt.Fprintln(w, "for q =")
	for i, e := range es {
		sep := ","
		if i == len(es)-1 {
			sep = ":"
		}
		fmt.Fprintf(w, "(%.1f,%.1f)--(%.1f,%.1f)%s\n",
			px(e[0]), py(e[0]), px(e[1]), py(e[1]), sep)
	}
	fmt.Fprintln(w, "draw q; endfor")
	fmt.Fprintln(w, "drawoptions();")
}

@* 크누스의 마디와 모서리 매듭. 둘 다 \pdfURL{\.{KTf.jpg}}%
{https://cs.stanford.edu/\TILDE/knuth/KTf.jpg}에서 읽어 낸 크누스의 실제 이음들이다
(그림 파일은 이 디렉터리에 있다). |knuthMod|은 곧은 변의 주기 6 마디(열여덟 이음)로,
위쪽 변의 띠 좌표(행 $0,1,2$)로 적었다. 열이 $6$을 넘는 이음은 다음 마디로 이어진다.
@<타입...@>=
var knuthMod = []edge{
	{{0, 0}, {1, 2}}, {{1, 0}, {2, 2}}, {{0, 1}, {1, 3}}, {{1, 1}, {0, 3}},
	{{2, 1}, {1, 3}}, {{2, 1}, {0, 2}}, {{0, 2}, {2, 3}}, {{1, 2}, {2, 4}},
	{{2, 2}, {1, 4}}, {{0, 3}, {1, 5}}, {{2, 3}, {0, 4}}, {{0, 4}, {2, 5}},
	{{1, 4}, {2, 6}}, {{2, 4}, {1, 6}}, {{0, 5}, {1, 7}}, {{0, 5}, {2, 6}},
	{{1, 5}, {0, 7}}, {{2, 5}, {0, 6}},
}

@ |knuthCorners|는 모서리를 도는 매듭 넷(저마다 서른 이음)이다. 두 변의 마디를 모서리
에서 이어 주며, 모서리 칸을 원점으로 한 좌표로 적었다. 크누스의 $55\times55$ 투어에서
마디를 걷어 낸 나머지를 네 모서리별로 갈라 얻은 것인데, $31\times31$에서 얻은 것과
글자 하나 다르지 않았다---크기와 무관한 그의 재료다.
@<타입...@>=
var knuthCorners = [4][]edge{@<모서리 매듭 넷@>}

@ 넷 가운데 $0$번이 기본꼴이다. $1$번과 $2$번은 서로 같고 기본꼴과 이음 다섯이 다르며,
$3$번은 이음 둘이 다르다. 그러니까 실제로는 {\it 세 종류\/}다. 바로 이 어긋남이 네
고리를 하나로 꿰는 건너뜀이라, 매듭을 제자리에 놓기만 하면 2-opt가 필요 없다.
@<모서리 매듭 넷@>=
{
	{{0, 0}, {1, 2}}, {{0, 0}, {2, 1}}, {{0, 1}, {1, 3}}, {{0, 1}, {2, 2}},
	{{0, 2}, {1, 0}}, {{0, 2}, {1, 4}}, {{0, 3}, {2, 2}}, {{0, 3}, {2, 4}},
	{{0, 4}, {1, 6}}, {{0, 4}, {2, 5}}, {{0, 5}, {2, 4}}, {{0, 6}, {1, 4}},
	{{1, 0}, {3, 1}}, {{1, 1}, {2, 3}}, {{1, 1}, {3, 0}}, {{1, 2}, {2, 0}},
	{{1, 3}, {2, 5}}, {{1, 5}, {2, 3}}, {{2, 0}, {3, 2}}, {{2, 1}, {4, 0}},
	{{3, 0}, {4, 2}}, {{3, 1}, {5, 2}}, {{3, 2}, {5, 1}}, {{4, 0}, {6, 1}},
	{{4, 1}, {6, 0}}, {{4, 1}, {6, 2}}, {{4, 2}, {5, 0}}, {{5, 0}, {6, 2}},
	{{5, 1}, {7, 0}}, {{5, 2}, {7, 1}},
},

@ $1$번과 $2$번---기본꼴에서 이음 다섯이 다르다.
@<모서리 매듭 넷@>=
{
	{{0, 0}, {1, 2}}, {{0, 0}, {2, 1}}, {{0, 1}, {1, 3}}, {{0, 1}, {2, 0}},
	{{0, 2}, {1, 0}}, {{0, 2}, {1, 4}}, {{0, 3}, {1, 1}}, {{0, 3}, {2, 4}},
	{{0, 4}, {1, 6}}, {{0, 4}, {2, 5}}, {{0, 5}, {2, 4}}, {{0, 6}, {1, 4}},
	{{1, 0}, {2, 2}}, {{1, 1}, {2, 3}}, {{1, 2}, {3, 1}}, {{1, 3}, {2, 5}},
	{{1, 5}, {2, 3}}, {{2, 0}, {3, 2}}, {{2, 1}, {4, 0}}, {{2, 2}, {3, 0}},
	{{3, 0}, {4, 2}}, {{3, 1}, {5, 2}}, {{3, 2}, {5, 1}}, {{4, 0}, {6, 1}},
	{{4, 1}, {6, 0}}, {{4, 1}, {6, 2}}, {{4, 2}, {5, 0}}, {{5, 0}, {6, 2}},
	{{5, 1}, {7, 0}}, {{5, 2}, {7, 1}},
},

@ @<모서리 매듭 넷@>=
{
	{{0, 0}, {1, 2}}, {{0, 0}, {2, 1}}, {{0, 1}, {1, 3}}, {{0, 1}, {2, 0}},
	{{0, 2}, {1, 0}}, {{0, 2}, {1, 4}}, {{0, 3}, {1, 1}}, {{0, 3}, {2, 4}},
	{{0, 4}, {1, 6}}, {{0, 4}, {2, 5}}, {{0, 5}, {2, 4}}, {{0, 6}, {1, 4}},
	{{1, 0}, {2, 2}}, {{1, 1}, {2, 3}}, {{1, 2}, {3, 1}}, {{1, 3}, {2, 5}},
	{{1, 5}, {2, 3}}, {{2, 0}, {3, 2}}, {{2, 1}, {4, 0}}, {{2, 2}, {3, 0}},
	{{3, 0}, {4, 2}}, {{3, 1}, {5, 2}}, {{3, 2}, {5, 1}}, {{4, 0}, {6, 1}},
	{{4, 1}, {6, 0}}, {{4, 1}, {6, 2}}, {{4, 2}, {5, 0}}, {{5, 0}, {6, 2}},
	{{5, 1}, {7, 0}}, {{5, 2}, {7, 1}},
},

@ $3$번---기본꼴에서 이음 {\it 둘\/}만 다르다.
@<모서리 매듭 넷@>=
{
	{{0, 0}, {1, 2}}, {{0, 0}, {2, 1}}, {{0, 1}, {1, 3}}, {{0, 1}, {2, 2}},
	{{0, 2}, {1, 0}}, {{0, 2}, {1, 4}}, {{0, 3}, {1, 1}}, {{0, 3}, {2, 4}},
	{{0, 4}, {1, 6}}, {{0, 4}, {2, 5}}, {{0, 5}, {2, 4}}, {{0, 6}, {1, 4}},
	{{1, 0}, {3, 1}}, {{1, 1}, {2, 3}}, {{1, 2}, {2, 0}}, {{1, 3}, {2, 5}},
	{{1, 5}, {2, 3}}, {{2, 0}, {3, 2}}, {{2, 1}, {4, 0}}, {{2, 2}, {3, 0}},
	{{3, 0}, {4, 2}}, {{3, 1}, {5, 2}}, {{3, 2}, {5, 1}}, {{4, 0}, {6, 1}},
	{{4, 1}, {6, 0}}, {{4, 1}, {6, 2}}, {{4, 2}, {5, 0}}, {{5, 0}, {6, 2}},
	{{5, 1}, {7, 0}}, {{5, 2}, {7, 1}},
},

@* 액자 투어를 짓는다. 매듭을 어느 모서리에 놓을지를 |asg|라 하자. 네 자리에 각각 넷 중
하나를 놓으니 배치는 $4^4=256$가지다. 크누스 자신의 배치 $(0,1,2,3)$부터 차례로 깔아
보아, {\it 하나의 닫힌 투어\/}가 되는 첫 배치를 쓴다. 기본값 $103\times73$을 비롯해
크기의 절반쯤은 크누스의 배치가 그대로 통하고, 나머지도 256가지 안에서 반드시 하나는
통한다(내가 아는 모든 크기에서 그랬다).
@<보조...@>=
func ringTour(Nh, Nw int) ([]edge, [4]int) {
	if es := layout(Nh, Nw, knuthAsg); oneLoop(es, Nh, Nw) {
		return sortEdges(es), knuthAsg
	}
	@<나머지 배치를 차례로 깔아 본다@>
	log.Fatalf("%d×%d 액자를 하나의 닫힌 투어로 짓지 못했다", Nh, Nw)
	return nil, knuthAsg
}

@ 크누스가 쓴 배치다---모서리를 도는 차례대로 $0,1,2,3$번 매듭.
@<타입...@>=
var knuthAsg = [4]int{0, 1, 2, 3}

@ 256가지를 네 자리 $4$진수로 세며 훑는다. 크누스의 배치는 이미 보았으니 건너뛴다.
@<나머지 배치를 차례로 깔아 본다@>=
for k := 0; k < 256; k++ {
	var asg [4]int
	for q := range asg {
		asg[q] = k >> (2 * q) & 3
	}
	if asg == knuthAsg {
		continue
	}
	if es := layout(Nh, Nw, asg); oneLoop(es, Nh, Nw) {
		return sortEdges(es), asg
	}
}

@ |layout|이 배치 하나를 실제로 깐다.
@<보조...@>=
func layout(Nh, Nw int, asg [4]int) map[edge]bool {
	es := map[edge]bool{}
	@<네 변에 마디를, 네 모서리에 매듭을 깐다@>
	return es
}

@ 위쪽 변은 그대로, 오른쪽 $\cdot$ 아래쪽 $\cdot$ 왼쪽 변은 $90^\circ$씩 돌린 네 변환으로
마디와 매듭을 함께 옮겨 놓는다. 마디는 오프셋 $5,11,\ldots$로 이어 깔되 모서리 다섯
칸은 매듭에 내주고, 두 끝이 모두 테두리 칸인 이음만 받는다.

@<네 변에 마디를, 네 모서리에 매듭을 깐다@>=
xf := []func(r, c int) cell{
	func(r, c int) cell { return cell{r, c} },
	func(r, c int) cell { return cell{c, Nw - 1 - r} },
	func(r, c int) cell { return cell{Nh - 1 - r, Nw - 1 - c} },
	func(r, c int) cell { return cell{Nh - 1 - c, r} },
}
length := []int{Nw, Nh, Nw, Nh}
put := func(a, b cell) {
	if isBorder(a, Nh, Nw) && isBorder(b, Nh, Nw) {
		es[canon(a, b)] = true
	}
}
for i, f := range xf {
	for off := 5; off <= length[i]-13; off += 6 {
		for _, e := range knuthMod {
			put(f(e[0][0], e[0][1]+off), f(e[1][0], e[1][1]+off))
		}
	}
	for _, e := range knuthCorners[asg[i]] {
		put(f(e[0][0], e[0][1]), f(e[1][0], e[1][1]))
	}
}

@ |loopID|는 각 칸에 그 칸이 속한 고리 번호를 매기고 고리 수를 돌려준다. 고리를 따라
걸으며 번호를 칠하면 되는데, 그러려면 모든 칸이 degree $2$여야 한다. 아니면 걸음이
막히므로 고리 수를 $-1$로 알린다.
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
	return id, n
}

@ |oneLoop|은 깔아 놓은 이음 집합이 우리가 바라는 것인지 본다: 테두리의 칸 수만큼
이음이 있고($6(N_h+N_w)-36$), 모든 칸이 degree $2$이며, 고리가 하나뿐인지. 앞의 둘은
|loopID|가 함께 가려 준다.
@<보조...@>=
func oneLoop(es map[edge]bool, Nh, Nw int) bool {
	if len(es) != 6*(Nh+Nw)-36 {
		return false
	}
	_, nl := loopID(es)
	return nl == 1
}

@ 매듭 넷을 한 줄의 수로 줄인 것이 {\it 지문\/}이다(FNV-1a). 이웃한 \.{ktf} 프로그램은
크누스의 투어에서 마디를 걷어 내 이 매듭을 {\it 스스로 뽑아내고\/} 같은 방식으로 지문을
찍는다. 그러니 두 수를 견주면 여기 적어 둔 재료가 그의 그림 그대로인지 한눈에 안다.
어느 한쪽을 잘못 건드리면 두 수가 갈라진다.
@<보조...@>=
func fingerprint(kn [4][]edge) uint32 {
	h := uint32(2166136261)
	for _, es := range kn {
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

@ |sortEdges|는 이음을 한 줄로 세워 돌려준다. 맵을 훑는 차례는 Go에서 뒤죽박죽이므로,
정렬해야 같은 입력에 늘 같은 \.{framedef.mp}가 나온다.
@<보조...@>=
func sortEdges(es map[edge]bool) []edge {
	out := make([]edge, 0, len(es))
	for e := range es {
		out = append(out, e)
	}
	sort.Slice(out, func(i, j int) bool { return lessE(out[i], out[j]) })
	return out
}

@* 매크로 파일을 쓴다. 명령행에서 받은 크기(기본 A4 비율 $103\times73$)의 세로와 가로 두
액자 투어를 지어 \.{framedef.mp}에 담는다. 각 방향을 {\it 선 색 $\cdot$ 배경색 $\cdot$ 선
굵기를 입력으로 받는\/} {\logo METAPOST} 매크로 \.{frameV()}(세로)$\cdot$
\.{frameH()}(가로)로 정의한다(\.{mpost} 토큰은 글자와 숫자를 못 섞으므로 이름에
숫자를 쓰지 않는다). 각 방향마다 지은 것이 하나의 닫힌 투어인지도 확인한다.

@ 프로그램이 내놓는 것은 매크로 정의뿐이다. 그것을 불러 그리는 \.{beginfig}는 손으로 쓴
\.{frame.mp}에 따로 둔다. 왜 갈라놓는가? 들여올 수 있게 하려면 그래야 한다. 정의와
\.{beginfig}를 한 파일에 함께 두면 그 파일 맨 끝에 \.{end.}가 와야 하는데, \.{end.}는
{\logo METAPOST}의 실행을 {\it 그 자리에서\/} 끝낸다. 그래서 다른 문서가 그 파일을
\.{input}하면 그림 둘이 나온 뒤 실행이 멈춰 버려, 정작 자기 \.{beginfig}는 돌지도 못한다.
정의만 담은 \.{framedef.mp}에는 \.{end.}가 없으니 이것을 들여오면 그럴 일이 없다---다른
문서가 \.{frameV(0.6red, 0.95white, 0.4pt)}처럼 선 색도 배경색도 굵기도 원하는 대로 액자를
다시 쓸 수 있다. \.{expr} 매개변수는 색 타입을 가리지 않으므로 RGB 세 원소든 CMYK 네
원소든 그대로 넘어간다.

@<액자 배경...@>=
@<명령행에서 액자 크기를 정한다@>
@<출력 파일을 연다@>
const u = 6.0
@<두 방향의 크기를 적어 둔다@>
for _, s := range shapes {
	es, asg := ringTour(s.Nh, s.Nw)
	@<지은 것이 하나의 닫힌 투어인지 확인한다@>
	@<매크로 하나를 정의한다@>
}
@<출력 파일을 닫는다@>

@ 낼 파일이 하나뿐이니 그저 열고, 누가 썼는지 밝히는 머리글 주석을 얹는다.
@<출력 파일을 연다@>=
out, err := os.Create("framedef.mp")
if err != nil {
	log.Fatal(err)
}
w := bufio.NewWriter(out)
fmt.Fprintln(w, `% framedef.mp — 크누스의 별무늬로 지은 닫힌 투어 액자 매크로 (frame.go가 씀).`)

@ @<두 방향의 크기를 적어 둔다@>=
shapes := []struct {
	name   string // 표준 출력용
	mp     string // {\logo METAPOST} 매크로 이름 (숫자를 못 섞으므로 글자만)
	Nh, Nw int
}{
	{"세로", "frameV", big, small},
	{"가로", "frameH", small, big},
}

@ @<매크로 하나를 정의한다@>=
fmt.Fprintf(w, "def %s(expr line, bg, pw) =\n", s.mp)
@<배경을 칠하고 프리즈를 그린다@>
fmt.Fprintln(w, "enddef;")
note := ""
if asg == knuthAsg {
	note = "(크누스의 것)"
}
fmt.Printf("%s 액자: %d×%d, 간선 %d개, 모서리 배치 %d%d%d%d%s, 하나의 닫힌 나이트 투어 ✓\n",
	s.name, s.Nh, s.Nw, len(es), asg[0], asg[1], asg[2], asg[3], note)

@ 끝으로 재료의 지문을 찍어, \.{ktf}가 그의 그림에서 뽑아낸 것과 견줄 수 있게 한다.
@<출력 파일을 닫는다@>=
w.Flush()
out.Close()
fmt.Printf("모서리 매듭 지문: %08x (ktf가 찍는 것과 같아야 한다)\n",
	fingerprint(knuthCorners))

@ 액자의 두 변 길이는 명령행에서 받는다---인자가 없으면 기본값 $103\times73$(A4 비율)을
쓰고, |가로 세로| 두 정수를 주면 그 크기로 짓는다. 두 방향(세로$\cdot$가로)을 늘 함께
내므로 두 인자의 순서는 결과를 바꾸지 않는다(큰 쪽이 세로, 작은 쪽이 가로가 된다). 각
변은 $13$ 이상이면서 $6$으로 나눈 나머지가 $1$이어야 네 고리가 하나로 이어진다.
@<명령행에서 액자 크기를 정한다@>=
big, small := 103, 73
switch len(os.Args) {
case 1:
case 3:
	var e1, e2 error
	big, e1 = strconv.Atoi(os.Args[1])
	small, e2 = strconv.Atoi(os.Args[2])
	if e1 != nil || e2 != nil {
		log.Fatalf("사용법: %s [가로 세로]", os.Args[0])
	}
default:
	log.Fatalf("사용법: %s [가로 세로]", os.Args[0])
}
if big < small {
	big, small = small, big
}
for _, n := range []int{big, small} {
	if n < 13 || n%6 != 1 {
		log.Fatalf("각 변은 13 이상, 6으로 나눈 나머지가 1이어야 한다 (받은 값: %d)", n)
	}
}

@ 프리즈를 그리기 전에, 액자가 감싸는 직사각형을 배경색 |bg|로 칠한다. 칸 중심들의
테두리 상자에 꼭 맞춰 칠하므로 그림 크기(=페이지에 앉는 자리)는 그대로다. 그 위에
프리즈를 선 색 |line|으로 얹는다.
@<배경을 칠하고 프리즈를 그린다@>=
xr := float64(s.Nw-1) / 2 * u
yr := float64(s.Nh-1) / 2 * u
fmt.Fprintf(w, "fill (%.1f,%.1f)--(%.1f,%.1f)--(%.1f,%.1f)--(%.1f,%.1f)--cycle withcolor bg;\n",
	-xr, -yr, xr, -yr, xr, yr, -xr, yr)
drawEdges(w, es, s.Nh, s.Nw, u)

@ 이음 집합을 다시 |loopID|에 넣어 고리가 하나뿐인지, 칸 수와 이음 수가 맞는지 본다.
@<지은 것이 하나의 닫힌 투어인지 확인한다@>=
esMap := map[edge]bool{}
for _, e := range es {
	esMap[e] = true
}
if _, nl := loopID(esMap); nl != 1 || len(es) != 6*(s.Nh+s.Nw)-36 {
	log.Fatalf("%s 액자가 닫힌 투어가 아니다 (고리 %d개, 이음 %d개)", s.name, nl, len(es))
}

@ 그려 놓고 보면 크누스의 \.{KTf}와 똑같은---별이 촘촘히 맞물린---폭 3칸 직사각
액자가 세로$\cdot$가로 두 방향으로 나온다. 둘 다 한 붓에 그린 진짜 닫힌 나이트
투어다. 세로짜리로 이 문서의 {\it 모든 페이지\/}가 둘려 있다.
\medskip
\centerline{\pic height 7cm{frame-1.pdf}\hskip 1cm\pic height 5cm{frame-2.pdf}}

@* 색인.
