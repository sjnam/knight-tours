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
  \moveleft.63in\hbox{\pic width 7.55in height 11.05in{frame-1.pdf}}\vss}%
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
%    \moveleft.55in\hbox{\pic width 7.55in height 10.65in{frame-1.pdf}}\vss}%
%  \vskip.6in \centerline{\titlefont\Gtitle}\vskip.7in\vfill}

% 코드 안의 한 조각만 빨갛게 물들이는 짝. gweave만 보고 gtangle은 지나치는
% @t...@> 안에 넣어 쓰므로 뽑아 낸 Go 소스에는 흔적이 남지 않는다. PDF의 색은
% 스택이라 TeX의 그룹에 갇히지 않고, 켠 자리부터 끈 자리까지 그대로 이어진다.
\def\redon{\pdfextension literal{1 0 0 rg}}
\def\redoff{\pdfextension literal{0 g}}

\font\logo=logo10

%\def\adj{\mathrel{\!\mathrel-\mkern-8mu\mathrel-\mkern-8mu\mathrel-\!}}
\def\adj{\mathrel{\!\mathrel-\mkern-8mu\mathrel-\!}}

\def\title{나이트 장식 액자}

@* 페이지를 두르는 나이트 액자. 크누스의 \pdfURL{{\it 나이트 투어 전시장}}%
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
차수(degree)가 $2$가 되기는 해도 변마다 고리 하나씩 {\it 네 개의 닫힌 고리\/}로 갈려서, 이웃한
두 고리를 2-opt로 이어 붙여 하나로 꿰야 했다. 그런데 그렇게 지은 액자를 크누스의 것과
간선 단위로 견주어 보니 모서리가 서로 달랐다. 2-opt가 바꿔치울 수 있는 이음이 하필
모서리에만 있었기 때문인데, 이 ``하필''이 실은 피할 길 없는 것이었음을 뒤에서 센다.

그래서 그의 투어에서 네 모서리를 {\it 따로따로\/} 읽어 내 보았다. 놀랍게도 넷이 같지
않았다---기본꼴 하나에, 이음 다섯이 다른 것과 둘이 다른 것, 그러니까 서로 다른 매듭
{\it 세 종류\/}를 그는 자리마다 골라 쓰고 있었다. 고리를 잇는 {\it 건너뜀이 매듭 안에
이미 들어 있는\/} 것이다. 그것이 그가 말한 ``everything clicked into place''의 정체다.
그래서 이 프로그램은 2-opt를 쓰지 않는다. 네 매듭을 어느 자리에 놓을지만 고르면
하나의 닫힌 투어가 저절로 나온다.

구성이 $N_h$, $N_w$의 매개변수이므로, 각 변이 $13$ 이상이면서 $6$으로 나눈 나머지가
$1$이기만 하면 어떤 직사각형이든 짓는다. 이 프로그램은 명령행이 시킨 크기로 액자를 하나 짓는다.
기본값은 $103\times73$(A4 비율)이고, 이 문서 자체가 그 액자를 사용하는 한 예가 되는데,
만든 액자를 곧바로 이 문서의 {\it 모든 페이지\/} 바탕에 깐다. 프로그램의 뼈대는 다음과 같다.

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

@* 기본 도구. 앞으로 일어날 한바탕 전투에 대비해서 필요한 자료 구조와 함수들을 만들어 두자.
먼저, 칸은 $(r,c)$로 적고, 이음(간선)은 두 칸의 쌍으로 적는다.
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

@ 이음 집합을 {\logo METAPOST} 선분들로 그린다. 펜(굵기 \.{pw})과 선 색(\.{line})은
\.{drawoptions}로 {\it 한 번만\/} 지정한다. {\logo METAPOST}의 \.{for}는 쉼표로
늘어놓은 값 목록을 그대로 돌 수 있으니, 배열도 인덱스도 없이 경로 목록을
\.{for q = 경로, 경로, ...: draw q; endfor}로 그린다---그래서 \.{framedef.mp}에는
\.{draw}도 한 번, 첨자도 없이 경로 `\.{()--()}' 데이터만 남는다. 끝나면 \.{drawoptions()}로
되돌려 다음 그림에 새지 않게 한다. 판의 위쪽이 위로 오도록 $y$를 뒤집고, 중심을 원점에 맞춘다.
@<보조...@>=
func drawEdges(w *bufio.Writer, es []edge, Nh, Nw int, u float64) {
	offx := float64(Nw-1) / 2
	offy := float64(Nh-1) / 2
	px := func(c cell) float64 { return (float64(c[1]) - offx) * u }
	py := func(c cell) float64 { return -(float64(c[0]) - offy) * u }
	fmt.Fprintln(w, "  drawoptions(withpen pencircle scaled pw withcolor line);")
	fmt.Fprintln(w, "  for q =")
	for i, e := range es {
		sep := ","
		if i == len(es)-1 {
			sep = ":"
		}
		fmt.Fprintf(w, "    (%.1f,%.1f)--(%.1f,%.1f)%s\n",
			px(e[0]), py(e[0]), px(e[1]), py(e[1]), sep)
	}
	fmt.Fprintln(w, "  draw q; endfor")
	fmt.Fprintln(w, "  drawoptions();")
}

@* 크누스의 마디와 모서리 매듭. 둘 다 \pdfURL{\.{KTf.jpg}}%
{https://cs.stanford.edu/\TILDE/knuth/KTf.jpg}에서 읽어 낸 크누스의 실제 이음들이다.
|knuthMod|는 곧은 변의 주기 6 마디(열여덟 이음)로,
위쪽 변의 띠 좌표(행 $0,1,2$)로 적었다. 열이 $6$을 넘는 이음은 다음 마디로 이어진다.
그림은 이 표를 여섯 칸씩 옮겨 세 벌 이어 깐 것인데, 가운데 빨간 한 벌이 표에 적힌
바로 그 열여덟 이음이다. 별이 촘촘히 맞물린 무늬가 마디 하나에서 나온다. 그림은
동봉한 \.{frame.mp}가 그린다---액자와 달리 재료는 크기에 따라 달라지지 않는 상수라
프로그램이 지을 까닭이 없어 손으로 적어 두었다. 격자와 점은
이 재료가 폭 3칸 테두리의 어디에 앉는지를 보이려는 것이고, 이음이 닿지 않은 칸에도
점이 있는데 그 칸의 이음은 이웃 마디에서 온다.
\smallskip
\centerline{\pic width 12cm{frame-3.pdf}}
\smallskip
@<타입...@>=
var knuthMod = []edge{
	{{0, 0}, {1, 2}}, {{1, 0}, {2, 2}}, {{0, 1}, {1, 3}}, {{1, 1}, {0, 3}},
	{{2, 1}, {1, 3}}, {{2, 1}, {0, 2}}, {{0, 2}, {2, 3}}, {{1, 2}, {2, 4}},
	{{2, 2}, {1, 4}}, {{0, 3}, {1, 5}}, {{2, 3}, {0, 4}}, {{0, 4}, {2, 5}},
	{{1, 4}, {2, 6}}, {{2, 4}, {1, 6}}, {{0, 5}, {1, 7}}, {{0, 5}, {2, 6}},
	{{1, 5}, {0, 7}}, {{2, 5}, {0, 6}},
}

@ 왜 하필 열여덟인가? 닫힌 투어에서는 모든 칸의 차수가 $2$이므로 차수의 합이 $2V$이면서
$2E$다. 곧 {\it 이음 수와 칸 수가 같다\/}. 마디는 곧은 변을 따라 여섯 칸 주기로
되풀이되니 한 주기가 품는 칸은 $6\times3=18$이고, 무한히 뻗은 띠에서도 $E=V$는 주기마다
성립하므로 한 마디의 이음도 열여덟이다. |knuthMod|의 항목이 열여덟인 것은 우연이 아니라
$6\times3$의 결과다. 같은 셈으로 폭 3칸 테두리 전체의 이음 수도 칸 수와 같은
$6(N_h+N_w)-4\times9$이다.

@ 변수 |knuthCorners|는 모서리를 도는 매듭 넷(저마다 서른 이음)이다. 두 변의 마디를 모서리
에서 이어 주며, 모서리 칸을 원점으로 한 좌표로 적었다. 크누스의 $55\times55$ 투어에서
마디를 걷어 낸 나머지를 네 모서리별로 갈라 얻은 것인데, $31\times31$에서 얻은 것과
글자 하나 다르지 않았다---크기와 무관한 그의 재료다.
@<타입...@>=
var knuthCorners = [4][]edge{
	@<0번 모서리 매듭@>
	@<1,2번 모서리 매듭@>
	@<1,2번 모서리 매듭@>
	@<3번 모서리 매듭@>
}

@ 넷 가운데 $0$번 모서리 매듭이 기본꼴이다. $1$번과 $2$번은 서로 같고 기본꼴과 이음 다섯이 다르며,
$3$번은 이음 둘이 다르다. 그러니까 실제로는 {\it 세 종류\/}다. 바로 이 어긋남이 네
고리를 하나로 꿰는 건너뜀이라, 매듭을 제자리에 놓기만 하면 2-opt가 필요 없다.

서른 이음을 눈으로 맞대어 보기는 성가시니, 기본꼴은 그대로 두고 뒤따르는 세 절에서
{\it 기본꼴과 다른 이음만\/} 빨갛게 찍어 두었다. 그러니 빨간 것만 눈으로 걷어 내면
어느 매듭이든 기본꼴로 돌아온다. 곁들인 그림도 같은 규칙이라, \.{frame.mp}는 세 매듭이
함께 지니는 스물다섯을 한 번만 적고 갈리는 자리만 따로 둔다. 두 팔이 ㄱ자로 꺾여 두 변의
마디를 이어 주는 모양이 보인다.
\smallskip
\centerline{\pic height 2.4cm{frame-4.pdf}}
\smallskip
@<0번 모서리 매듭@>=
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

@ 1, 2번 모서리 매듭은 0번 기본꼴에서 이음 다섯이 다르다. 빨간 다섯이 그것이고, 나머지 스물다섯은
기본꼴 그대로다.
\smallskip
\centerline{\pic height 2.4cm{frame-5.pdf}}
\smallskip
@<1,2번 모서리 매듭@>=
{
	{{0, 0}, {1, 2}}, {{0, 0}, {2, 1}}, {{0, 1}, {1, 3}}, @t\redon@>{{0, 1}, {2, 0}}@t\redoff@>,
	{{0, 2}, {1, 0}}, {{0, 2}, {1, 4}}, @t\redon@>{{0, 3}, {1, 1}}@t\redoff@>, {{0, 3}, {2, 4}},
	{{0, 4}, {1, 6}}, {{0, 4}, {2, 5}}, {{0, 5}, {2, 4}}, {{0, 6}, {1, 4}},
	@t\redon@>{{1, 0}, {2, 2}}@t\redoff@>, {{1, 1}, {2, 3}}, @t\redon@>{{1, 2}, {3, 1}}@t\redoff@>, {{1, 3}, {2, 5}},
	{{1, 5}, {2, 3}}, {{2, 0}, {3, 2}}, {{2, 1}, {4, 0}}, @t\redon@>{{2, 2}, {3, 0}}@t\redoff@>,
	{{3, 0}, {4, 2}}, {{3, 1}, {5, 2}}, {{3, 2}, {5, 1}}, {{4, 0}, {6, 1}},
	{{4, 1}, {6, 0}}, {{4, 1}, {6, 2}}, {{4, 2}, {5, 0}}, {{5, 0}, {6, 2}},
	{{5, 1}, {7, 0}}, {{5, 2}, {7, 1}},
},

@ 3번 모서리 매듭은 기본꼴에서 이음 {\it 둘\/}만 다르다. 그 둘도 $1$번이 바꾼 다섯 가운데
둘이니, 세 매듭이 손대는 자리는 모두 같은 구석이다. 앞 그림의 빨간 자리와 견주어 보면
빨강이 두 곳으로 줄었을 뿐 같은 언저리임이 보인다.
\smallskip
\centerline{\pic height 2.4cm{frame-6.pdf}}
\smallskip
@<3번 모서리 매듭@>=
{
	{{0, 0}, {1, 2}}, {{0, 0}, {2, 1}}, {{0, 1}, {1, 3}}, {{0, 1}, {2, 2}},
	{{0, 2}, {1, 0}}, {{0, 2}, {1, 4}}, @t\redon@>{{0, 3}, {1, 1}}@t\redoff@>, {{0, 3}, {2, 4}},
	{{0, 4}, {1, 6}}, {{0, 4}, {2, 5}}, {{0, 5}, {2, 4}}, {{0, 6}, {1, 4}},
	{{1, 0}, {3, 1}}, {{1, 1}, {2, 3}}, {{1, 2}, {2, 0}}, {{1, 3}, {2, 5}},
	{{1, 5}, {2, 3}}, {{2, 0}, {3, 2}}, {{2, 1}, {4, 0}}, @t\redon@>{{2, 2}, {3, 0}}@t\redoff@>,
	{{3, 0}, {4, 2}}, {{3, 1}, {5, 2}}, {{3, 2}, {5, 1}}, {{4, 0}, {6, 1}},
	{{4, 1}, {6, 0}}, {{4, 1}, {6, 2}}, {{4, 2}, {5, 0}}, {{5, 0}, {6, 2}},
	{{5, 1}, {7, 0}}, {{5, 2}, {7, 1}},
},

@ 그럼 매듭은 왜 {\it 서른\/}인가? 이쪽은 세어서 얻은 값이 아니라 나머지가 맞아떨어지도록
{\it 강제되는\/} 값이다. $N_h=6p+1$, $N_w=6q+1$이라 하자. |layout|은 마디를 오프셋
$5,11,\ldots$로 깔되 $L-13$에서 멈추므로, 길이 $L=6k+1$인 변이 받는 마디는 $5+6j\le6k-12$를
푼 $k-2$개다. 네 변을 합하면 $2(p+q)-8$개. 매듭 하나의 이음 수를 $C$라 하면
$$18\bigl(2(p+q)-8\bigr)+4C=6(N_h+N_w)-36=36(p+q)-24$$
이고, 좌변을 펴면 $36(p+q)-144+4C$이니 $4C=120$, 곧 $C=30$이다.

$p$와 $q$가 깨끗이 지워진다는 것이 요점이다. 서른은 액자 크기와 {\it 무관한\/} 상수다.
그의 매듭을 $31\times31$에서 읽든 $55\times55$에서 읽든 글자 하나 다르지 않았던 까닭이,
그리고 매듭 표 하나로 모든 크기를 짓는 까닭이 여기 있다.

@ 미덥지 않으면 마디 몫과 매듭 몫을 따로 세어 보면 된다.

\medskip
\centerline{\vbox{\halign{\hfil#\hfil&&\quad\hfil#\hfil\cr
크기& 마디& 마디 이음& 매듭 이음& 합& $6(N_h+N_w)-36$\cr
\noalign{\smallskip\hrule\smallskip}
$103\times73$& 50& 900& 120& 1020& 1020\cr
$55\times55$& 28& 504& 120& 624& 624\cr
$31\times31$& 12& 216& 120& 336& 336\cr
$19\times13$& 2& 36& 120& 156& 156\cr
$13\times13$& 0& 0& 120& 120& 120\cr}}}
\medskip

마디와 매듭이 겹치는 이음은 하나도 없고, |isBorder|에 걸려 버려지는 이음도
하나도 없다. 두 재료가 딱 맞물려 테두리를 빈틈없이 덮는다는 뜻이다.

맨 아랫줄이 특히 예쁘다---$13\times13$은 마디가 {\it 아예 없고\/} 매듭 넷이 전부다
($4\times30=120$). 각 변이 $13$ 이상이어야 하는 까닭이 이것이니, $13$은 매듭 넷이 서로
밀치지 않고 겨우 들어맞는 가장 작은 크기다.

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

@ 함수 |layout|이 배치 하나를 실제로 깐다.
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

@ 함수 |loopID|는 각 칸에 그 칸이 속한 고리 번호를 매기고 고리 수를 돌려준다. 고리를 따라
걸으며 번호를 칠하면 되는데, 그러려면 모든 칸이 차수가 $2$여야 한다. 아니면 걸음이
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

@ 함수 |oneLoop|은 깔아 놓은 이음 집합이 우리가 바라는 것인지 본다: 테두리의 칸 수만큼
이음이 있고($6(N_h+N_w)-36$), 모든 칸이 차수가 $2$이며, 고리가 하나뿐인지. 앞의 둘은
|loopID|가 함께 가려 준다.
@<보조...@>=
func oneLoop(es map[edge]bool, Nh, Nw int) bool {
	if len(es) != 6*(Nh+Nw)-36 {
		return false
	}
	_, nl := loopID(es)
	return nl == 1
}

@ 여기서 차수가 $2$와 고리 수 사이를 짚어 두자. 어떤 칸의 차수란 거기 붙은 이음의
개수다. 닫힌 투어에서 나이트는 칸마다 한 번 들어와 한 번 나가므로 모든 칸의 차수가
정확히 $2$다. 그러니 차수 $2$는 투어의 {\it 필요조건\/}이다.

충분조건은 아니다. 모든 칸이 차수 $2$인 이음 집합은 하나의 큰 고리일 수도, 여러 개의
작은 고리일 수도 있다---그래프 이론에서 2-factor라 부르는 것이다. {\bf들어가며}에서 말한 네
고리가 바로 그 짝이다. 매듭 하나만 네 모서리에 돌려 놓고 $103\times73$을 지으면
$1020$칸이 {\it 모두\/} 차수가 $2$인데도 고리는 넷으로 갈린다. 크기는 $106$, $404$,
$404$, $106$---긴 변 둘과 짧은 변 둘이 저마다 자기 고리다. 나이트가 위쪽 변을 뱅뱅 돌
뿐 오른쪽 변으로 넘어가지 못한다. |loopID|가 차수와 고리 수를 {\it 둘 다\/} 보는
까닭이 이것이다.

그 네 고리를 하나로 꿰는 데 쓴 것이 2-opt다. 원래 외판원 문제를 푸는 고전적 개선
수법으로(Croes, 1958), 이름 그대로 이음 {\it 둘\/}을 바꿔치우는 동작이다. 이음 $a\adj b$와
$c\adj d$를 골라 지우고, 끝점을 엇갈리게 $a\adj c$와 $b\adj d$로 다시 잇는다.
\smallskip
%\centerline{\pic width 11.5cm{frame-2.pdf}}
\centerline{\pic{frame-2.pdf}}
\smallskip
\noindent 같은 고리에서 두 이음을 고르면 고리는 끊어지지 않고 가운데 구간이 뒤집힐
뿐이다---외판원의 길을 줄일 때 쓰는 용법이 그것이다. 그런데 {\it 서로 다른\/} 두 고리에서
고르면 그림처럼 둘이 하나로 합쳐진다. 옛 코드가 쓴 것이 이쪽이고, 합칠 때마다 고리가
하나씩 주니 넷을 하나로 만들자면 세 번 해야 했다.

외판원 문제와 다른 점이 하나 있다. 거기서는 어느 두 도시든 이을 수 있지만 여기서는
새로 만드는 $a\adj c$와 $b\adj d$가 {\it 둘 다 진짜 나이트 이동\/}이어야 한다. 그래서 아무
데서나 되지 않는다. $103\times73$에서 서로 다른 고리를 잇는 2-opt를 죄다 세어 보면
열두 가지뿐이고, 거기 나오는 칸은 하나도 빠짐없이 모서리에서 여섯 칸 안쪽이다.

생각해 보면 당연하다. 두 고리가 나이트 이동 거리 안으로 다가서는 데가 모서리밖에
없으니까. 곧은 변 한가운데의 두 고리는 수십 칸씩 떨어져 있어 이을 방법이 아예 없다.
그러니 2-opt를 쓰는 한 모서리의 이음은 {\it 반드시\/} 바뀌고, 크누스의 그림과는 반드시
어긋난다. 매듭 넷을 제자리에 놓는 지금 방식이 답인 까닭이 여기 있다.

@ 재료를 한 줄의 수로 줄인 것이 {\it 지문\/}이다(FNV-1a). 마디와 매듭 넷을 모두 넣어
찍으므로 이 프로그램이 지닌 재료 전부를 덮는다. 이웃한 \.{frames} 프로그램도 같은 방식으로
지문을 찍는데, 그쪽의 마디는 크누스가 적어 둔 모티프로 검증한 것이고 매듭은 그의 투어에서
{\it 스스로 뽑아낸\/} 것이다. 그러니 두 수를 견주면 여기 적어 둔 재료가 그의 그림 그대로
인지 한눈에 안다.
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

@ 함수 |sortEdges|는 이음을 한 줄로 세워 돌려준다. 맵을 훑는 차례는 Go에서 뒤죽박죽이므로,
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

@* 매크로 파일을 쓴다. 명령행에서 받은 크기(기본 A4 비율 $103\times73$)로 액자 투어를
지어 \.{framedef.mp}에 담는다. 그것을 {\it 선 색 $\cdot$ 배경색 $\cdot$ 선 굵기를
입력으로 받는\/} {\logo METAPOST} 매크로 \.{frame()} 하나로 정의한다. 지은 것이
하나의 닫힌 투어인지도 확인한다.

@ 프로그램이 내놓는 것은 매크로 정의뿐이다. 그것을 불러 그리는 \.{beginfig}는 손으로 쓴
\.{frame.mp}에 따로 둔다---이 문서가 싣는 그림 여섯은 죄다 그 한 파일에서 나온다.
왜 갈라놓는가? 들여올 수 있게 하려면 그래야 한다. 정의와
\.{beginfig}를 한 파일에 함께 두면 그 파일 맨 끝에 \.{end.}가 와야 하는데, \.{end.}는
{\logo METAPOST}의 실행을 {\it 그 자리에서\/} 끝낸다. 그래서 다른 문서가 그 파일을
\.{input}하면 그림이 나온 뒤 실행이 멈춰 버려, 정작 자기 \.{beginfig}는 돌지도 못한다.
정의만 담은 \.{framedef.mp}에는 \.{end.}가 없으니 이것을 들여오면 그럴 일이 없다---다른
문서가 \.{frame(0.6red, 0.95white, 0.4pt)}처럼 선 색도 배경색도 굵기도 원하는 대로 액자를
다시 쓸 수 있다. \.{expr} 매개변수는 색 타입을 가리지 않으므로 \.{RGB} 세 원소든 \.{CMYK} 네
원소든 그대로 넘어간다.

@<액자 배경...@>=
@<명령행에서 액자 크기를 정한다@>
@<출력 파일을 연다@>
const u = 6.0
es, asg := ringTour(Nh, Nw)
@<지은 것이 하나의 닫힌 투어인지 확인한다@>
@<매크로를 정의한다@>
@<출력 파일을 닫는다@>

@ 낼 파일이 하나뿐이니 그저 열고, 누가 썼는지 밝히는 머리글 주석을 얹는다.
@<출력 파일을 연다@>=
out, err := os.Create("framedef.mp")
if err != nil {
	log.Fatal(err)
}
w := bufio.NewWriter(out)
fmt.Fprintln(w, `% framedef.mp — 크누스의 별무늬로 지은 닫힌 투어 액자 매크로 (frame.go가 씀).`)

@ @<매크로를 정의한다@>=
fmt.Fprintln(w, "def frame(expr line, bg, pw) =")
@<배경을 칠하고 프리즈를 그린다@>
fmt.Fprintln(w, "enddef;")
note := ""
if asg == knuthAsg {
	note = "(크누스의 것)"
}
fmt.Printf("액자: %d×%d, 간선 %d개, 모서리 배치 %d%d%d%d%s, 하나의 닫힌 나이트 투어 ✓\n",
	Nh, Nw, len(es), asg[0], asg[1], asg[2], asg[3], note)

@ 끝으로 재료의 지문을 찍어, \.{frames}가 지닌 것과 견줄 수 있게 한다.
@<출력 파일을 닫는다@>=
w.Flush()
out.Close()
fmt.Printf("재료 지문: %08x (frames가 찍는 것과 같아야 한다)\n",
	fingerprint(knuthMod, knuthCorners))

@ 액자의 두 변 길이는 명령행에서 받는다---인자가 없으면 기본값 $103\times73$(A4 비율)을
쓰고, $N_h\,N_w$ 두 정수를 주면 그 크기로 짓는다. 이제는 인자를 넘겨받은 순서 그대로
쓰므로 순서가 결과를 바꾼다. 그래서 가로 액자가 필요하면 그저 두 수를 바꿔 주면 된다.
각 변은 $13$ 이상이면서 $6$으로 나눈 나머지가 $1$이어야 네 고리가 하나로 이어진다.
@<명령행에서 액자 크기를 정한다@>=
Nh, Nw := 103, 73
switch len(os.Args) {
case 1:
case 3:
	var e1, e2 error
	Nh, e1 = strconv.Atoi(os.Args[1])
	Nw, e2 = strconv.Atoi(os.Args[2])
	if e1 != nil || e2 != nil {
		log.Fatalf("사용법: %s [세로 가로]", os.Args[0])
	}
default:
	log.Fatalf("사용법: %s [세로 가로]", os.Args[0])
}
for _, n := range []int{Nh, Nw} {
	if n < 13 || n%6 != 1 {
		log.Fatalf("각 변은 13 이상, 6으로 나눈 나머지가 1이어야 한다 (받은 값: %d)", n)
	}
}

@ 프리즈를 그리기 전에, 액자가 감싸는 직사각형을 배경색 |bg|로 칠한다. 칸 중심들의
테두리 상자에 꼭 맞춰 칠하므로 그림 크기(=페이지에 앉는 자리)는 그대로다. 그 위에
프리즈를 선 색 |line|으로 얹는다.
@<배경을 칠하고 프리즈를 그린다@>=
xr := float64(Nw-1) / 2 * u
yr := float64(Nh-1) / 2 * u
fmt.Fprintf(w, "  fill (%.1f,%.1f)--(%.1f,%.1f)--(%.1f,%.1f)--(%.1f,%.1f)--cycle withcolor bg;\n",
	-xr, -yr, xr, -yr, xr, yr, -xr, yr)
drawEdges(w, es, Nh, Nw, u)

@ 이음 집합을 다시 |loopID|에 넣어 고리가 하나뿐인지, 칸 수와 이음 수가 맞는지 본다.
@<지은 것이 하나의 닫힌 투어인지 확인한다@>=
esMap := map[edge]bool{}
for _, e := range es {
	esMap[e] = true
}
if _, nl := loopID(esMap); nl != 1 || len(es) != 6*(Nh+Nw)-36 {
	log.Fatalf("액자가 닫힌 투어가 아니다 (고리 %d개, 이음 %d개)", nl, len(es))
}

@ 그려 놓고 보면 크누스의 \.{KTf}와 똑같은---별이 촘촘히 맞물린---폭 3칸 직사각
액자가 나온다. 한 붓에 그린 진짜 닫힌 나이트 투어다. 바로 이것으로 이 문서의
{\it 모든 페이지\/}가 둘려 있다.

@* 색인.
