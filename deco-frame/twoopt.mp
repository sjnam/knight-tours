% twoopt.mp — 2-opt가 두 고리를 하나로 합치는 그림 (frame.w가 씀).
verbatimtex \documentclass{article} \usepackage{kotex} \begin{document} etex

numeric r, gap, panel;
r := 24;      % 육각형 반지름
gap := 66;    % 두 고리의 중심 거리
panel := 150; % 오른쪽 판까지의 거리

pair L[], R[];
def setup(expr dx) =
  for k = 0 upto 5:
    L[k] := (dx,0) + r * dir(30 + 60k);
    R[k] := (dx + gap,0) + r * dir(30 + 60k);
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

beginfig(1);
  drawoptions(withpen pencircle scaled .5pt);

  % 왼쪽 판: 고리 둘. 곧 지울 두 이음을 빨갛게.
  setup(0);
  hexbut(L, 5); hexbut(R, 2);
  draw L5--L0 withcolor red; draw R2--R3 withcolor red;
  label.urt(btex $a$ etex, L0); label.lrt(btex $b$ etex, L5);
  label.ulft(btex $c$ etex, R2); label.llft(btex $d$ etex, R3);
  label.bot(btex 고리 둘 etex, (gap/2, -r-7));

  % 화살표.
  drawarrow (gap+32, 0)--(panel-32, 0);
  label.top(btex 2-opt etex, ((gap+panel)/2, 3));

  % 오른쪽 판: 두 이음을 지우고 엇갈리게 이으면 고리 하나.
  setup(panel);
  hexbut(L, 5); hexbut(R, 2);
  draw L0--R2 withcolor red; draw L5--R3 withcolor red;
  label.top(btex $a$ etex, L0); label.bot(btex $b$ etex, L5);
  label.top(btex $c$ etex, R2); label.bot(btex $d$ etex, R3);
  label.bot(btex 고리 하나 etex, (panel+gap/2, -r-7));

  drawoptions();
endfig;

end.
