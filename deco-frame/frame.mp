% frame.mp — frame.w가 싣는 모든 그림을 그리는 드라이버 (손으로 쓴 것).
%
% 그림 1은 framedef.mp의 액자 매크로를 기본 흑백으로 불러 그린 것이고(그것이 이 문서의
% 모든 페이지 바탕에 깔린다), 나머지는 본문 그림이다. 액자만 frame.go가 짓는다---그것만
% 명령행이 준 크기에 따라 달라지기 때문이다. 나머지 그림의 재료는 크기와 무관한 상수라
% 여기 손으로 적어 두었다.
%
%   frame-1.pdf  액자 (framedef.mp에서)
%   frame-2.pdf  2-opt가 두 고리를 하나로 합치는 그림
%   frame-3.pdf  마디 프리즈 (세 벌, 가운데가 빨강)
%   frame-4.pdf  0번 모서리 매듭 (기본꼴)
%   frame-5.pdf  1·2번 모서리 매듭
%   frame-6.pdf  3번 모서리 매듭
%   frame-7.pdf  한 변이 두 칸씩 맞물린 사슬 (길이 31을 예로)
%
% 그림 3~6의 좌표는 frame.w의 knuthMod·knuthCorners 표를 (행,열) 그대로 옮긴 것이다.
% 좌표가 두 벌인 셈이니 표를 고치는 날에는 이 파일도 함께 고쳐야 한다.

verbatimtex \documentclass{article} \usepackage{kotex} \begin{document} etex

input framedef;

% 그림 1 --- 액자. 선 색, 배경색, 선 굵기를 주면 그린다.
beginfig(1); frame(black, white, 0.2pt); endfig;

% 그림 2 --- 2-opt. 육각 고리 둘에서 이음 둘을 지우고 엇갈리게 이으면 고리 하나가 된다.

numeric rad, gap, panel;
rad := 24;    % 육각형 반지름
gap := 66;    % 두 고리의 중심 거리
panel := 150; % 오른쪽 판까지의 거리

pair L[], R[];
def setup(expr dx) =
  for k = 0 upto 5:
    L[k] := (dx,0) + rad * dir(30 + 60k);
    R[k] := (dx + gap,0) + rad * dir(30 + 60k);
  endfor
enddef;

% 육각형을 그리되 s번 꼭짓점에서 시작하는 변 하나는 건너뛴다. 왼쪽 고리는 5번 변
% (=$L_5L_0$, 곧 $a\,b$)을, 오른쪽 고리는 2번 변(=$R_2R_3$, 곧 $c\,d$)을 뺀다.
def hexbut(suffix P)(expr s) =
  for k = 0 upto 5:
    if k <> s:
      if k = 5: draw P[5]--P[0]; else: draw P[k]--P[k+1]; fi
    fi
  endfor
  for k = 0 upto 5: fill fullcircle scaled 2.4 shifted P[k]; endfor
enddef;

beginfig(2);
  drawoptions(withpen pencircle scaled .5pt);

  % 왼쪽 판: 고리 둘. 곧 지울 두 이음을 빨갛게.
  setup(0);
  hexbut(L, 5); hexbut(R, 2);
  draw L5--L0 withcolor red; draw R2--R3 withcolor red;
  label.urt(btex $a$ etex, L0); label.lrt(btex $b$ etex, L5);
  label.ulft(btex $c$ etex, R2); label.llft(btex $d$ etex, R3);
  label.bot(btex 고리 둘 etex, (gap/2, -rad-7));

  % 화살표.
  drawarrow (gap+32, 0)--(panel-32, 0);
  label.top(btex 2-opt etex, ((gap+panel)/2, 3));

  % 오른쪽 판: 두 이음을 지우고 엇갈리게 이으면 고리 하나.
  setup(panel);
  hexbut(L, 5); hexbut(R, 2);
  draw L0--R2 withcolor red; draw L5--R3 withcolor red;
  label.top(btex $a$ etex, L0); label.bot(btex $b$ etex, L5);
  label.top(btex $c$ etex, R2); label.bot(btex $d$ etex, R3);
  label.bot(btex 고리 하나 etex, (panel+gap/2, -rad-7));

  drawoptions();
endfig;

% 그림 3~6 --- 재료. 매듭 셋을 통째로 세 번 적지는 않았다. 넷 가운데 서로 다른 것이
% 셋뿐이고 그 셋이 스물다섯 이음을 함께 지니니, 공통분(common)을 한 번만 적고 갈리는
% 자리만 따로 둔다. frame.w가 "빨간 것만 걷어 내면 기본꼴로 돌아온다"고 한 구조 그대로다.

numeric uu; uu := 8;

% 이음 하나. 행이 아래로 자라야 하니 y를 뒤집는다.
def e(expr ra, ca, rb, cb) =
  draw (ca*uu, -ra*uu)--(cb*uu, -rb*uu);
enddef;

def blackpen = drawoptions(withpen pencircle scaled .5pt); enddef;
def redpen   = drawoptions(withpen pencircle scaled .5pt withcolor red); enddef;

% 폭 3칸 테두리 모양으로 격자를 깔고 칸마다 점을 찍는다. 마디는 maxr=2라 곧은 띠가,
% 매듭은 maxr=7이라 ㄱ자가 된다. 재료가 판의 어디에 앉는지가 격자만 보아도 드러난다.
def grid(expr maxr, maxc) =
  drawoptions(withpen pencircle scaled .3pt withcolor .75white);
  for r = 0 upto maxr: for c = 0 upto maxc:
    if (r <= 2) or (c <= 2):
      draw unitsquare scaled uu shifted ((c-.5)*uu, (-r-.5)*uu);
    fi
  endfor endfor
  drawoptions();
  for r = 0 upto maxr: for c = 0 upto maxc:
    if (r <= 2) or (c <= 2):
      fill fullcircle scaled 1.2 shifted (c*uu, -r*uu);
    fi
  endfor endfor
enddef;

% knuthMod — 곧은 변의 주기 6 마디, 열여덟 이음.
def modul =
  e(0,0, 1,2); e(0,1, 1,3); e(0,2, 2,3);
  e(0,3, 1,5); e(0,4, 2,5); e(0,5, 1,7);
  e(0,5, 2,6); e(1,0, 2,2); e(1,1, 0,3);
  e(1,2, 2,4); e(1,4, 2,6); e(1,5, 0,7);
  e(2,1, 0,2); e(2,1, 1,3); e(2,2, 1,4);
  e(2,3, 0,4); e(2,4, 1,6); e(2,5, 0,6);
enddef;

% 세 매듭이 함께 지니는 스물다섯 이음.
def common =
  e(0,0, 1,2); e(0,0, 2,1); e(0,1, 1,3);
  e(0,2, 1,0); e(0,2, 1,4); e(0,3, 2,4);
  e(0,4, 1,6); e(0,4, 2,5); e(0,5, 2,4);
  e(0,6, 1,4); e(1,1, 2,3); e(1,3, 2,5);
  e(1,5, 2,3); e(2,0, 3,2); e(2,1, 4,0);
  e(3,0, 4,2); e(3,1, 5,2); e(3,2, 5,1);
  e(4,0, 6,1); e(4,1, 6,0); e(4,1, 6,2);
  e(4,2, 5,0); e(5,0, 6,2); e(5,1, 7,0);
  e(5,2, 7,1);
enddef;

% 0번(기본꼴)만 지니는 다섯.
def basefive =
  e(0,1, 2,2); e(0,3, 2,2); e(1,0, 3,1);
  e(1,1, 3,0); e(1,2, 2,0);
enddef;

% 1·2번만 지니는 다섯. 기본꼴의 저 다섯을 대신한다.
def altfive =
  e(0,1, 2,0); e(0,3, 1,1); e(1,0, 2,2);
  e(1,2, 3,1); e(2,2, 3,0);
enddef;

% 3번은 둘만 갈린다: 기본꼴의 다섯 가운데 셋은 그대로 두고,
def keepthree =
  e(0,1, 2,2); e(1,0, 3,1); e(1,2, 2,0);
enddef;

% 나머지 둘을 1·2번의 것으로 바꾼다.
def swaptwo =
  e(0,3, 1,1); e(2,2, 3,0);
enddef;

% 그림 3 — 마디. 홀로 두면 무늬가 보이지 않으므로 여섯 칸씩 옮겨 세 벌을 이어 깐다.
% 가운데 한 벌만 빨갛게 하여 그 열여덟 이음이 주기 하나임을 짚는다.
beginfig(3);
  grid(2, 19);
  blackpen; picture mb; mb := image(modul);
  redpen;   picture mr; mr := image(modul);
  drawoptions();
  draw mb; draw mr shifted (6uu, 0); draw mb shifted (12uu, 0);
endfig;

% 그림 4 — 0번 모서리 매듭(기본꼴).
beginfig(4);
  grid(7, 6); blackpen; common; basefive; drawoptions();
endfig;

% 그림 5 — 1·2번. 기본꼴과 갈리는 다섯이 빨강.
beginfig(5);
  grid(7, 6); blackpen; common; redpen; altfive; drawoptions();
endfig;

% 그림 6 — 3번. 갈리는 것이 둘뿐이라 빨강도 둘이다.
beginfig(6);
  grid(7, 6); blackpen; common; keepthree; redpen; swaptwo; drawoptions();
endfig;

% 그림 7 — 한 변에 재료가 앉는 자리. 길이 31인 변을 예로 들어, 매듭과 마디가 덮는 열
% 구간을 층층이 늘어놓았다. 세로 띠가 겹치는 자리인데 어디서나 폭이 꼭 두 열이다.
% ba/bb는 층마다의 시작 열과 끝 열---layout이 off = 5, 11, 17로 마디를 까는 그것이다.

numeric cw, bh, bg, nlev, side;
cw := 9;    % 한 열의 너비
bh := 12;   % 막대 높이
bg := 17;   % 층 사이 간격
nlev := 4;  % 맨 아래 층 번호
side := 31; % 예로 든 변의 길이

numeric ba[], bb[];
ba0 := 0;  bb0 := 6;   % 가까운 모서리의 매듭
ba1 := 5;  bb1 := 12;  % 마디 (off=5)
ba2 := 11; bb2 := 18;  % 마디 (off=11)
ba3 := 17; bb3 := 24;  % 마디 (off=17)
ba4 := 23; bb4 := 30;  % 먼 모서리의 매듭

beginfig(7);
  defaultscale := .7;

  % 겹치는 두 열을 세로 띠로 밝힌다.
  for p = 5, 11, 17, 23:
    fill unitsquare xscaled 2cw yscaled (nlev*bg + bh + 8)
      shifted (p*cw, -nlev*bg - 4) withcolor (1, .87, .87);
  endfor

  % 층마다 막대 하나. 열 ba부터 bb까지를 덮는다.
  for k = 0 upto nlev:
    fill unitsquare xscaled ((bb[k] + 1 - ba[k])*cw) yscaled bh
      shifted (ba[k]*cw, -k*bg) withcolor .94white;
    draw unitsquare xscaled ((bb[k] + 1 - ba[k])*cw) yscaled bh
      shifted (ba[k]*cw, -k*bg) withpen pencircle scaled .4pt;
  endfor

  label(btex 매듭 $0\ldots6$ etex,       ((ba0 + bb0 + 1)/2*cw, bh/2));
  label(btex 마디 $5\ldots12$ etex,      ((ba1 + bb1 + 1)/2*cw, -bg + bh/2));
  label(btex 마디 $11\ldots18$ etex,     ((ba2 + bb2 + 1)/2*cw, -2bg + bh/2));
  label(btex 마디 $17\ldots24$ etex,     ((ba3 + bb3 + 1)/2*cw, -3bg + bh/2));
  label(btex 매듭 $23\ldots30$ etex,     ((ba4 + bb4 + 1)/2*cw, -4bg + bh/2));

  % 열 눈금. 겹침이 시작하고 끝나는 열만 적는다.
  numeric yr; yr := -nlev*bg - 13;
  draw (0, yr)--(side*cw, yr) withpen pencircle scaled .4pt;
  for p = 0, 5, 6, 11, 12, 17, 18, 23, 24, 30:
    draw ((p + .5)*cw, yr)--((p + .5)*cw, yr - 3) withpen pencircle scaled .4pt;
    label.bot(decimal p, ((p + .5)*cw, yr - 3));
  endfor
  label.lft(btex 열 etex, (-3, yr));
endfig;

end.
