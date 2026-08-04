% ktknot.mp — 나이트 투어를 켈트 매듭(Celtic knot)으로 그리는 매크로 꾸러미.
%
% 크누스의 Selected Papers on Fun and Games 41장 Celtic Knight's Tours가 밑감이다.
% 거기 실린 그림들과 그의 사진 https://cs.stanford.edu/~knuth/KTg.jpg에 걸린
% 걸개그림들을 이 파일 하나로 다시 그린다.
%
% 쓰는 법은 이렇다.
%
%   beginfig(1);
%     walllook;  uu := 22bp;
%     newtour;  K(0,1); K(2,2); ... ;
%     showknot(false, true, true);
%   endfig;
%
% K가 방문 순서대로 칸을 하나씩 적고, showknot이 그것을 매듭으로 짜서 놓는다.
% 인자 셋은 차례로 closed, vert, grid다.
%
%   closed  닫힌 투어인가. 참이면 마지막 칸에서 첫 칸으로 되돌아온다.
%   vert    참이면 적은 그대로, 거짓이면 90도 눕혀 놓는다. 투어는 사진 속 걸개그림이
%           걸린 모습대로 세로로 적으니, 참이 벽 모습이고 거짓이 책 모습이다.
%   grid    참이면 판의 격자를 함께 깐다.
%
% uu는 K가 칸을 적을 때 곧바로 쓰이니 반드시 newtour보다 먼저 정해야 한다.
%
% 차림새를 부른 뒤에 낱낱을 다시 고쳐도 된다. 차림새가 하는 일은 그저 매개변수를
% 한꺼번에 정해 주는 것뿐이라, 뒤에 오는 대입이 이긴다. 이를테면 판 둘레의 여백 띠를
% 두 배로 넓히거나 아예 없애려면 이렇게 한다.
%
%   walllook;  uu := 22bp;  brim := 1.2;   % 띠를 넓게
%   walllook;  uu := 22bp;  brim := 0;     % 띠 없이 격자를 가장자리까지
%
% 끈을 도드라져 보이게 하는 relief와 cast도 이렇게 켠다. 밑값이 0이라 그냥 두면
% 납작하게 나온다.
%
%   paperlook;  uu := 26bp;  relief := 1.1;  cast := .05;
%
% 매듭이 되는 까닭은 41장 첫머리에 있다. 평면 위의 닫힌 곡선이 한 점을 두 번 넘게
% 지나지 않는다면, 만날 때마다 위아래를 번갈아 짤 수 있다. 가우스가 1844년 12월
% 30일 공책에 증명 없이 적어 둔 사실이다. 그러니 길을 따라가며 만나는 교차점에
% 위·아래·위·아래를 차례로 매기기만 하면 된다. 같은 교차점을 두 번째로 지날 때
% 앞서와 반대가 나오는지는 drawknot이 확인해 준다.
%
% 이 파일은 홀로 선다---바깥에서 input하는 것도, TeX 라벨도 없다.

% 사진 속 걸개그림에서 끈의 굵기를 재니 한 칸의 0.107배였다. 그것을 밑값으로 삼는다.
numeric uu;   uu   := 22bp;    % 한 칸의 크기
numeric hw;   hw   := .054;    % 리본 반폭 (칸 단위)
numeric gap;  gap  := .032;    % 아래 가닥을 위 가닥의 테두리에서 더 물리는 틈
numeric bulb; bulb := 2.2;     % 열린 투어 끝에 다는 구슬의 반지름 (리본 반폭 배)
numeric wire; wire := .4bp;    % 테두리 선의 굵기. 0이면 테두리를 안 그린다.
boolean roundjoin;             % 참이면 꺾이는 자리를 진짜 끈처럼 둥글게 잇고,
roundjoin := true;             % 거짓이면 마이터로 별 끝처럼 뾰족하게 잇는다.
numeric bend; bend := 1;       % 둥글게 이을 때 바깥 호의 반지름 (리본 반폭 배). 1이
                               % 가장 뾰족하고, 키울수록 끝이 뭉툭해진다.

% 끈을 종이 위에 도드라져 보이게 하는 세 가지. 빛이 어디서 오는지를 lit으로 정하고,
% relief가 테두리 굵기를 그 빛에 따라 달리하고, cast가 위 가닥의 그림자를 아래 가닥에
% 드리운다. 둘 다 0이 밑값이라 그냥 두면 예전처럼 납작하게 그린다. 크누스의 책 그림도
% 납작하다---스캔에서 좌우 선 굵기가 달라 보이는 것은 209 dpi에 0.4bp 선이 1.16화소로
% 찍히며 생긴 무늬일 뿐, 같은 선 하나가 길이를 따라 진했다 흐렸다 한다.
numeric lit;    lit    := 135; % 빛이 오는 쪽 (도). 135면 왼쪽 위에서 비친다.
numeric relief; relief := 0;   % 빛을 등진 변을 얼마나 굵게 할까 (wire의 배수)
numeric cast;   cast   := 0;   % 잘린 끝에 드리우는 그림자의 길이 (칸 단위)
color shade;    shade  := .72white;  % 그림자 빛깔

color ink;   ink   := black;   % 리본 테두리 빛깔
color pulp;  pulp  := white;   % 리본 속 빛깔
color mesh;  mesh  := .78white;% 타일 테두리 빛깔
color tilea; tilea := white;   % 어두운 칸의 빛깔 (열+행이 짝수)
color tileb; tileb := white;   % 밝은 칸의 빛깔 (열+행이 홀수)
color slab;  slab  := white;   % 판 바깥 여백의 빛깔
color hair;   hair  := black;  % 리본 대신 가는 선 하나로만 그릴 때의 선 빛깔.
numeric hairw; hairw := .5pt;  % 이 꾸러미는 안 쓰고, frieze.mp처럼 격자만 빌려다
                               % 쓰는 그림이 차림새를 따라가게 하려고 둔다.
numeric brim; brim := .6;      % 판 둘레에 두는 여백 띠의 폭 (칸 단위). 0이면 띠가
                               % 없어 격자가 그림 가장자리까지 꽉 찬다.
numeric seam; seam := .08;     % 타일 사이에 두는 틈 (칸 단위)
numeric bevel; bevel := 0;     % 타일 모서리를 둥글리는 반지름 (칸 단위)
numeric rim;  rim  := .4bp;    % 타일 테두리 선의 굵기
numeric tilephase;             % 0이면 왼쪽 위 칸이 어둡고 1이면 밝다. 판이 벽의
tilephase := 0;                % 타일 위에 어느 위상으로 놓였나에 따라 갈린다.

% 두 가지 차림새. 종이는 크누스의 책에 실린 꼴이라 흰 바탕에 가는 테두리만 있고
% 꺾이는 자리가 마이터로 길게 뻗어 별처럼 뾰족하다. 벽은 그의 사진 속 걸개그림이라
% 검은 바탕에 흰 끈이 도드라지고, 진짜 끈이 그렇듯 모서리가 둥글다.
%
% 벽 쪽 bend는 사진에서 재어 1.8로 잡았다. 재는 법이 조금 까다로웠다. 끝이 어디까지
% 나갔는지로 견주면 격자를 어디에 맞췄느냐에 따라 답이 흔들린다. 그래서 끝점 자체를
% 기준으로 삼았다. 가장 날카로운 자리(36.87도)의 흰 덩이에서 이등분선 방향으로 가장
% 멀리 나간 점을 찾고, 거기서 1화소씩 물러나며 폭을 재면 격자와 무관한 숫자가 나온다.
% 사진은 7.1, 7.8, 9.9, 9.9, 11.3, 11.3이었고 bend가 1.8일 때 5.7, 7.1, 9.9, 9.9,
% 11.3, 11.3으로 가장 가까웠다. 1.5는 너무 뾰족했고 2.0은 끝이 납작했다.
def paperlook =
  ink := black; pulp := white; slab := white; mesh := .78white;
  tilea := white; tileb := white; tilephase := 0;
  hair := black; hairw := .5pt;
  brim := .6; seam := .08; bevel := 0; rim := .4bp;
  hw := .038; gap := 0;    bulb := 2.0; wire := .4bp; roundjoin := true;
  bend := 1;
  lit := 135; relief := 0; cast := 0; shade := .72white;
enddef;
def walllook =
  ink := black; pulp := white; slab := .075white;
  tilea := .10white; tileb := .17white; mesh := .38white; tilephase := 0;
  hair := white; hairw := .8pt;
  brim := .6; seam := .17; bevel := .04; rim := .7bp;
  hw := .054; gap := .032; bulb := 2.2; wire := 0; roundjoin := true;
  bend := 1.8;
  relief := 0; cast := 0;
enddef;

% ============================================================================
% 투어 적기
% ============================================================================
% 칸 (x,y)는 x가 열, y가 행이고 행은 아래로 자란다. 화면 좌표는 y를 뒤집는다.

numeric tn; pair tv[];
def newtour = tn := 0; enddef;
def K(expr x, y) = tv[tn] := (x*uu, -y*uu); tn := tn + 1; enddef;

% 판의 자리는 blo·bhi 둘로 적는다. 이것을 정하는 길이 둘 있다. measureboard는 적어
% 둔 투어에서 재고, setboard는 열과 행의 수로 곧바로 정한다. backdrop과 gridboard는
% 둘 다 blo·bhi만 보니, 투어가 없는 그림도 격자를 빌려다 쓸 수 있다. frieze.mp가
% 그렇게 쓴다. 다만 둘 중 하나를 반드시 먼저 불러야 한다.
pair blo, bhi;
def setboard(expr nc, nr) =
  blo := (-.5uu, -(nr - .5)*uu);
  bhi := ((nc - .5)*uu, .5uu);
enddef;

% 투어를 다 적은 뒤에 불러야 한다.
def measureboard =
  blo := bhi := tv[0];
  for i = 1 upto tn-1:
    blo := (min(xpart blo, xpart tv[i]), min(ypart blo, ypart tv[i]));
    bhi := (max(xpart bhi, xpart tv[i]), max(ypart bhi, ypart tv[i]));
  endfor
  blo := blo - (.5uu, .5uu); bhi := bhi + (.5uu, .5uu);
enddef;

% 바탕. mg는 판 둘레로 더 두는 여백이다(칸 단위).
def backdrop(expr mg) =
  fill (blo - (mg*uu, mg*uu)) -- (xpart bhi + mg*uu, ypart blo - mg*uu)
    -- (bhi + (mg*uu, mg*uu)) -- (xpart blo - mg*uu, ypart bhi + mg*uu)
    -- cycle withcolor slab;
enddef;

% 격자. 사진 속 걸개그림처럼 칸마다 조금씩 떨어진 타일로 깔고, 체스판이 그렇듯
% 명암을 번갈아 준다. 사진에서 타일 속 밝기를 재어 보니 열과 행을 더해 짝수인 칸이
% 어둡고(255분의 22~33) 홀수인 칸이 밝았다(255분의 41~48). 밝기가 아래로 갈수록
% 조금씩 오르는 것은 사진의 빛 탓이라 여기서는 따르지 않았다.
%
% 격자가 눈에 들어오는 까닭은 면의 명암이 아니라 테두리다. 사진을 가로로 훑어 화소를
% 하나씩 재 보면 타일 테두리에서 90~111이 나온다---면(22~28과 42~50)보다도, 틈
% (18~22)보다도 훨씬 밝다. 어두운 칸은 면만 놓고 보면 틈과 구별이 안 갈 만큼 어두운데,
% 그 밝은 테두리 하나로 또렷이 드러난다. 도드라지지 않으면서 눈에 잘 띄는 것이 이
% 덕이다. 처음에는 테두리를 .22white로 어둡게 두었더니 면에 묻혀 격자가 흐려 보였다.
% 틈도 사진에서 재니 한 칸의 0.18배로 꽤 넓다(타일 한 변이 0.83칸). 네 귀는 둥글되
% 아주 조금이다. 걸개그림이 없는 맨 벽을 800배로 늘여 화소를 세어 보면 한 변이 43화소인
% 타일에서 귀가 2화소쯤 깎였을 뿐이니, 반지름이 한 칸의 0.04배다. 그래서 타일을
% unitsquare가 아니라 tilepath로 그린다.
%
% 그리는 자리는 왼쪽 아래를 원점으로 세지만 칸의 행 번호는 위에서부터 세니, 아래에서
% cy번째 줄이 곧 위에서 nr-1-cy번째 줄이다. 짝홀을 따질 때 그만큼을 되돌려 놓는다.
% 어느 쪽이 어두운가는 걸개그림마다 다르다. 벽 전체가 한 장의 타일 판이고 그 위에
% 판이 놓이는 위상이 저마다여서다. 실제로 왼쪽 맨 위 3x16은 왼쪽 위 칸이 어둡고,
% 오른쪽 맨 위 6x6은 밝다. 그래서 tilephase로 뒤집을 수 있게 두었다.

% 타일 하나의 테두리. 한 변이 s이고 네 귀를 반지름 r로 둥글린 네모다. r이 0이면
% 그냥 네모난 unitsquare로 돌아간다. 사분원은 베지에가 넉넉히 흉내 낸다.
vardef tilepath(expr s, r) =
  if r <= 0: unitsquare scaled s
  else:
    (r,0) -- (s-r,0){right} .. {up}(s,r) -- (s,s-r){up} .. {left}(s-r,s)
      -- (r,s){left} .. {down}(0,s-r) -- (0,r){down} .. {right}cycle
  fi
enddef;

def gridboard =
  begingroup
    save nc, nr, cx, cy, side, tile;
    numeric nc, nr, cx, cy, side; path tile;
    nc := round((xpart bhi - xpart blo)/uu);
    nr := round((ypart bhi - ypart blo)/uu);
    side := (1 - seam)*uu;
    for cx = 0 upto nc-1: for cy = 0 upto nr-1:
      tile := tilepath(side, bevel*uu)
                shifted (blo + ((cx + .5seam)*uu, (cy + .5seam)*uu));
      fill tile withcolor
        if (cx + nr - 1 - cy + tilephase) mod 2 = 0: tilea else: tileb fi;
      if rim > 0: draw tile withpen pencircle scaled rim withcolor mesh; fi
    endfor endfor
  endgroup
enddef;

% 매듭 하나를 매개변수대로 놓는다. 바탕·격자·매듭을 한 그림으로 합친 뒤에 돌리는
% 것이 요령이다. 따로 그리고 돌리면 격자만 제자리에 남는다.
% 눕혀 놓을 때는 빛도 함께 돌아가 버린다. 그림을 -90도 돌리니 왼쪽 위에서 오던 빛이
% 오른쪽 위에서 오는 꼴이 된다. 그래서 그리기 전에 lit을 90도 미리 되돌려 둔다.
% 그래야 세로로 놓든 가로로 놓든 종이 위에서는 늘 왼쪽 위에서 빛이 온다.
def showknot(expr closed, vert, grid) =
  begingroup
    save pp, keeplit; picture pp; numeric keeplit;
    keeplit := lit;
    if not vert: lit := lit + 90; fi
    pp := image(
      measureboard;
      backdrop(brim);
      if grid: gridboard; fi
      drawknot(closed);
    );
    lit := keeplit;
    draw if vert: pp else: pp rotated -90 fi;
  endgroup
enddef;

% ============================================================================
% 잔손질
% ============================================================================

% 두 직선이 만나는 곳. intersectionpoint는 선분끼리만 보니 넉넉히 늘여 준다.
% 나이트 투어에서 잇단 두 걸음이 이루는 각은 36.87도, 53.13도, 90도뿐이라 나란한
% 경우가 없다. 마이터가 언제나 잡힌다는 뜻이다.
numeric far; far := 12uu;
vardef xline(expr p, u, q, v) =
  ((p - far*u) -- (p + far*u)) intersectionpoint ((q - far*v) -- (q + far*v))
enddef;

% 중심 c, 반지름 r인 원호. 각 aa에서 시계 반대 방향으로 각 bb까지.
vardef arcpath(expr c, r, aa, bb) =
  save m, k; numeric m, k;
  m := bb; forever: exitif m > aa; m := m + 360; endfor
  (for k = 0 step 6 until m-aa-3: (c + r*dir(aa+k)) .. endfor (c + r*dir m))
enddef;

% 테두리 한 변의 펜 굵기. n은 그 변이 바깥을 보는 쪽의 단위 법선이다. 빛을 마주보는
% 변은 wire 그대로 두고 등진 변만 굵힌다. 반대로 마주보는 쪽을 가늘게도 해 보았는데,
% 그러면 밝은 쪽이 0.2bp도 안 되게 얇아져 인쇄에서 끊길 만해 한쪽으로만 키웠다.
vardef edgepen(expr n) =
  wire*(1 + relief*.5*(1 - (n dotprod dir lit)))
enddef;

% 원호를 긋는다. 호 위에서는 바깥 법선이 자리마다 달라지니 6도씩 토막 내어 토막마다
% 굵기를 새로 잡는다. 중심에서 밖으로 뻗는 방향이 곧 그 자리의 바깥 법선이다.
% relief가 0이면 어차피 굵기가 한결같으니 arcpath를 통째로 한 번에 긋는다. 토막으로
% 끊으면 베지에가 직선으로 바뀌어---차이가 반지름의 천분의 일도 안 되기는 하나---
% 입체감을 끈 그림이 켜기 전 그림과 한 획도 다르지 않기를 바라서다.
def drawarc(expr c, r, aa, bb) =
  if relief = 0:
    draw arcpath(c, r, aa, bb) withpen pencircle scaled wire withcolor ink;
  else:
    begingroup
      save m, k, t; numeric m, k, t;
      m := bb; forever: exitif m > aa; m := m + 360; endfor
      k := aa;
      forever:
        t := min(k + 6, m);
        draw (c + r*dir k) -- (c + r*dir t)
          withpen pencircle scaled edgepen(dir(.5(k+t))) withcolor ink;
        k := t;
        exitif k >= m;
      endfor
    endgroup
  fi
enddef;

% ============================================================================
% 매듭 짜기
% ============================================================================
% 하는 일은 넷이다.
%   1. 꼭짓점마다 리본 양옆의 마이터 점을 잡는다.
%   2. 걸음끼리 만나는 곳을 모두 찾아 걸음마다 거리순으로 줄 세운다.
%   3. 길을 따라가며 교차점에 위아래를 번갈아 매긴다.
%   4. 아래로 지나는 자리를 도려내고, 남은 토막마다 리본을 그린다.
%
% 4번이 요령이다. 도려내고 나면 어떤 토막도 서로 겹치지 않으니 그리는 차례를 따질
% 일이 없다. 위에서 아래로 덮어 그리는 흔한 수법과 달리 배경이 무엇이든 상관없고,
% 흰 종이든 검은 벽걸이든 같은 코드로 그려진다.

def drawknot(expr closed) =
begingroup
  save cyc, ne, i, j, k, l, c, o, d, seq, nx, dr, nm, ln, tt, newcut;
  save den, kl, kr, hp, sal, sar, sbl, sbr, sL, sR, back;
  save LA, RA, LB, RB, cea, ceb, cta, ctb, cov, cst, xn, xc, xs;
  save cn, caL, caR, cbL, cbR;
  boolean cyc, newcut;
  numeric ne, i, j, k, l, c, o, d, seq, nx, ln[];
  numeric den, kl, kr, hp, sal, sar, sbl, sbr, sL, sR, back;
  pair dr[], nm[], LA[], RA[], LB[], RB[], tt;
  numeric cea[], ceb[], cta[], ctb[], cov[], cst[];
  numeric xn[], xc[][], xs[][];
  numeric cn[], caL[][], caR[][], cbL[][], cbR[][];

  cyc := closed;
  ne := if cyc: tn else: tn - 1 fi;
  tv[tn] := tv[0];                 % 닫힌 투어가 제자리로 돌아오도록 한 칸 덧붙인다

  measuresteps;
  corners;
  findcrossings;
  weave;
  cutunders;
  drawribbons;
  if roundjoin: roundjoins; fi
  if not cyc: capends; fi
endgroup
enddef;

def measuresteps =
  for k = 0 upto ne-1:
    dr[k] := unitvector(tv[k+1] - tv[k]);
    nm[k] := dr[k] rotated 90;
    ln[k] := abs(tv[k+1] - tv[k]);
  endfor
enddef;

% 걸음마다 리본 양옆의 네 귀퉁이를 잡는다. LA·RA가 걸음이 시작하는 쪽, LB·RB가
% 끝나는 쪽이다. 먼저 넷 다 걸음에 직각으로 놓고, 꺾이는 자리에서만 고쳐 잡는다.
%
% 마이터로 이으면 36.87도로 꺾이는 자리에서 귀퉁이가 반폭의 세 배쯤 뻗어 별 끝처럼
% 뾰족해진다. 크누스의 책 그림에 보이는 그 긴 뿔이 그것이다. 반대로 진짜 끈은 둥글게
% 돌아 나간다. 둥글게 이을 때도 안쪽은 마이터로 모으고---그래야 두 리본의 테두리가
% 한 점에서 만나 안쪽에 군더더기 선이 남지 않는다---바깥쪽만 비워 두었다가 뒤에서
% 부채꼴로 메운다.
%
% 바깥 호의 반지름이 bend다(반폭의 배수). bend가 1이면 호가 꼭짓점을 중심으로 도니
% 리본 끝을 걸음에 직각으로 그냥 두면 되지만, 그보다 크면 호가 두 바깥 선에 닿는
% 자리가 꼭짓점에서 물러난다. 그만큼 리본도 물러나야 호 밖으로 삐져나오지 않는다.
% 물러나는 길이가 back이다. 꺾이는 각을 psi라 하면 (bend-1)*hw*uu*tan(psi/2)이고,
% 걸음 방향이 단위 벡터이니 sin psi가 곧 d, cos psi가 곧 내적이라 tan(psi/2)를
% |d|/(1+내적)으로 바로 얻는다.
def corners =
  for k = 0 upto ne-1:
    LA[k] := tv[k]   + hw*uu*nm[k];  RA[k] := tv[k]   - hw*uu*nm[k];
    LB[k] := tv[k+1] + hw*uu*nm[k];  RB[k] := tv[k+1] - hw*uu*nm[k];
  endfor
  for i = 0 upto tn-1:
    if cyc or ((i > 0) and (i < tn-1)):
      k := if i > 0: i-1 else: ne-1 fi;
      d := xpart dr[k] * ypart dr[i] - ypart dr[k] * xpart dr[i];
      if abs(d) > .0001:            % 두 걸음이 나란하면 꺾이지 않으니 그냥 둔다
        if (d > 0) or (not roundjoin):     % d>0이면 왼쪽으로 꺾으니 안쪽은 왼쪽
          LB[k] := xline(LA[k], dr[k], LA[i], dr[i]);  LA[i] := LB[k];
        fi
        if (d < 0) or (not roundjoin):
          RB[k] := xline(RA[k], dr[k], RA[i], dr[i]);  RA[i] := RB[k];
        fi
        if roundjoin:
          back := (bend - 1)*hw*uu*abs(d)/(1 + (dr[k] dotprod dr[i]));
          if d > 0: RB[k] := RB[k] - back*dr[k];  RA[i] := RA[i] + back*dr[i];
          else:     LB[k] := LB[k] - back*dr[k];  LA[i] := LA[i] + back*dr[i];
          fi
        fi
      fi
    fi
  endfor
enddef;

% 둥글게 이을 때 꺾이는 바깥쪽에 남는 틈을 부채꼴로 메운다. 안쪽 마이터 점까지 닫아
% 채우니 틈이 생길 여지가 없고, 테두리는 바깥 호만 긋는다. 호의 중심은 리본이 물러난
% 끝에서 안쪽으로 반지름만큼 들어간 자리다. 그래야 호가 두 바깥 선에 정확히 접한다.
def roundjoins =
  for i = 0 upto tn-1:
    if cyc or ((i > 0) and (i < tn-1)):
      k := if i > 0: i-1 else: ne-1 fi;
      d := xpart dr[k] * ypart dr[i] - ypart dr[k] * xpart dr[i];
      if abs(d) > .0001:
        if d > 0:                                      % 바깥은 오른쪽
          wedge(RB[k] + bend*hw*uu*nm[k], RB[k], RA[i], LB[k]);
        else:                                          % 바깥은 왼쪽
          wedge(LB[k] - bend*hw*uu*nm[k], LA[i], LB[k], RB[k]);
        fi
      fi
    fi
  endfor
enddef;

def wedge(expr c, pa, pb, ip) =
  begingroup
    save p; path p;
    p := arcpath(c, bend*hw*uu, angle(pa - c), angle(pb - c));
    fill p -- ip -- cycle withcolor pulp;
    if wire > 0: drawarc(c, bend*hw*uu, angle(pa - c), angle(pb - c)); fi
  endgroup
enddef;

% 걸음 둘이 꼭짓점을 함께 쓰면 건너뛴다. 나이트 걸음은 안쪽에 격자점을 품지
% 않으니(gcd(1,2)=1) 한 걸음이 다른 걸음의 끝을 꿰뚫는 일은 없다. 그래서 만남은
% 모두 두 걸음의 속살끼리다.
def findcrossings =
  nx := 0;
  for k = 0 upto ne-1: xn[k] := 0; endfor
  for k = 0 upto ne-2: for l = k+1 upto ne-1:
    if (l <> k+1) and ((k <> 0) or (l <> ne-1) or (not cyc)):
      tt := (tv[k] -- tv[k+1]) intersectiontimes (tv[l] -- tv[l+1]);
      if xpart tt > 0:
        cea[nx] := k; ceb[nx] := l;
        cta[nx] := (xpart tt)*ln[k]; ctb[nx] := (ypart tt)*ln[l];
        cov[nx] := -1; cst[nx] := 0;
        addcross(k, cta[nx], nx);  addcross(l, ctb[nx], nx);
        nx := nx + 1;
      fi
    fi
  endfor endfor
enddef;

% 걸음 k 위의 교차점 c를 거리 s 자리에 끼워 넣는다. 삽입 정렬이다.
def addcross(expr k, s, c) =
  begingroup
    save j; numeric j; j := xn[k];
    forever:
      exitif j = 0;
      exitif xs[k][j-1] <= s;
      xs[k][j] := xs[k][j-1]; xc[k][j] := xc[k][j-1]; j := j - 1;
    endfor
    xs[k][j] := s; xc[k][j] := c; xn[k] := xn[k] + 1;
  endgroup
enddef;

% 길을 따라가며 짝수 번째 만남을 위로 올린다. 가우스의 정리 덕에 같은 교차점의 두
% 번째 만남은 반드시 홀수 번째가 되고, 그래서 위아래가 어긋나지 않는다. 어긋난다면
% 그 투어는 매듭으로 짜이지 않는다는 뜻이니 소리 내어 알린다.
def weave =
  seq := 0;
  for k = 0 upto ne-1: for j = 0 upto xn[k]-1:
    c := xc[k][j];
    if seq mod 2 = 0: cov[c] := k; cst[c] := cst[c] + 1; fi
    seq := seq + 1;
  endfor endfor
  for c = 0 upto nx-1:
    if cst[c] <> 1:
      message "! 이 투어는 켈트 매듭으로 짜이지 않는다 (교차점 " & decimal c & ").";
    fi
  endfor
enddef;

% 아래로 지나는 가닥을 어디서 끊을지 잰다. 여기가 크누스의 그림을 흉내 내는 데
% 가장 중요한 대목이다. 걸음에 직각으로 뚝 자르면 안 된다---그러면 비스듬히 만나는
% 자리에서 끊긴 자국이 위 가닥과 어긋나 어색해진다. 크누스의 그림에서는 아래 가닥의
% 두 테두리가 저마다 위 가닥의 테두리에 가서 닿는다. 곧 자르는 선이 걸음이 아니라
% {\it 위 가닥\/}과 나란하다. 그래서 아래 가닥의 왼쪽과 오른쪽이 서로 다른 거리에서
% 끊기고, 잘린 자국이 비스듬해진다.
%
% 재는 법. 위 가닥 o의 중심선에서 잰 부호 있는 거리를 f라 하면, 아래 가닥 k의 왼쪽
% 테두리 위 점은 거리 s에서 f = kl + s*den이다. 여기서 den은 dr[k]와 nm[o]의 내적,
% 곧 sin θ다. 이것이 ±(반폭+틈)이 되는 s를 풀면 된다. 오른쪽 테두리도 마찬가지로
% kr로 푼다. 그렇게 얻은 네 값이 잘린 자국 두 개의 양 끝이다.
def cutunders =
  for k = 0 upto ne-1: cn[k] := 0; endfor
  for k = 0 upto ne-1: for j = 0 upto xn[k]-1:
    c := xc[k][j];
    if cov[c] <> k:
      o := if cea[c] = k: ceb[c] else: cea[c] fi;
      den := dr[k] dotprod nm[o];
      d   := (tv[k] - tv[o]) dotprod nm[o];
      kl  := d + hw*uu*(nm[k] dotprod nm[o]);
      kr  := d - hw*uu*(nm[k] dotprod nm[o]);
      hp  := if den > 0: (hw + gap)*uu else: -(hw + gap)*uu fi;
      sal := (-hp - kl)/den;  sar := (-hp - kr)/den;   % 위 가닥에 들어서는 자리
      sbl := ( hp - kl)/den;  sbr := ( hp - kr)/den;   % 빠져나오는 자리
      newcut := true;                        % MetaPost의 and는 앞이 거짓이어도 뒤를
      if cn[k] > 0:                          % 따지니, 첨자가 -1이 되지 않게 나눠 묻는다
        if max(cbL[k][cn[k]-1], cbR[k][cn[k]-1]) >= min(sal, sar):
          if max(sbl, sbr) > max(cbL[k][cn[k]-1], cbR[k][cn[k]-1]):
            cbL[k][cn[k]-1] := sbl;  cbR[k][cn[k]-1] := sbr;   % 앞자리와 겹치면 잇는다
          fi
          newcut := false;
        fi
      fi
      if newcut:
        caL[k][cn[k]] := sal;  caR[k][cn[k]] := sar;
        cbL[k][cn[k]] := sbl;  cbR[k][cn[k]] := sbr;
        cn[k] := cn[k] + 1;
      fi
    fi
  endfor endfor
enddef;

def drawribbons =
  for k = 0 upto ne-1:
    sL := 0; sR := 0;
    for j = 0 upto cn[k]-1:
      if min(caL[k][j], caR[k][j]) > max(sL, sR):
        ribbon(k, sL, sR, caL[k][j], caR[k][j]);
      fi
      sL := cbL[k][j];  sR := cbR[k][j];
    endfor
    if ln[k] > max(sL, sR): ribbon(k, sL, sR, ln[k], ln[k]); fi
  endfor
enddef;

% 걸음 k의 한 토막을 리본으로 그린다. 왼쪽 테두리는 saL에서 sbL까지, 오른쪽은
% saR에서 sbR까지다. 넷이 따로 노는 덕에 잘린 자국이 비스듬해진다. 끝이 꼭짓점에
% 닿으면(거리가 0이거나 걸음 길이 이상이면) 앞서 잡아 둔 귀퉁이를 그대로 쓴다.
def ribbon(expr k, saL, saR, sbL, sbR) =
  begingroup
    save la, lb, ra, rb, cl; pair la, lb, ra, rb; numeric cl;
    la := if saL <= 0: LA[k] else: tv[k] + saL*dr[k] + hw*uu*nm[k] fi;
    ra := if saR <= 0: RA[k] else: tv[k] + saR*dr[k] - hw*uu*nm[k] fi;
    lb := if sbL >= ln[k]: LB[k] else: tv[k] + sbL*dr[k] + hw*uu*nm[k] fi;
    rb := if sbR >= ln[k]: RB[k] else: tv[k] + sbR*dr[k] - hw*uu*nm[k] fi;
    fill la -- lb -- rb -- ra -- cycle withcolor pulp;
    if cast > 0:
      cl := min(cast*uu,
                .4*(min(min(sbL, sbR), ln[k]) - max(max(saL, saR), 0)));
      if cl > 0: shadowends(k, saL, saR, sbL, sbR, la, ra, lb, rb, cl); fi
    fi
    if wire > 0:
      draw la -- lb withpen pencircle scaled edgepen(nm[k]) withcolor ink;
      draw ra -- rb withpen pencircle scaled edgepen(-nm[k]) withcolor ink;
    fi
  endgroup
enddef;

% 위로 지나는 가닥이 아래 가닥에 드리우는 그림자. 위 가닥이 도려낸 자국은 걸음 하나에
% 두 군데 생기는데---앞서 지나간 자리와 앞으로 지날 자리---그림자는 그중 한쪽에만
% 진다. 빛이 lit 쪽에서 오면 그림자는 그 반대쪽으로 지니, 잘린 끝에서 리본이 뻗어
% 나가는 방향이 -dir lit과 같은 편인 쪽이 그늘에 든다. 자국이 비스듬하므로 그림자도
% 자국과 나란한 평행사변형으로 깐다. 토막이 짧으면 그 길이의 5분의 2로 줄인다.
def shadowends(expr k, saL, saR, sbL, sbR, la, ra, lb, rb, cl) =
  if max(saL, saR) > 0:
    if (dr[k] dotprod dir lit) < 0:
      fill la -- ra -- (ra + cl*dr[k]) -- (la + cl*dr[k]) -- cycle
        withcolor shade;
    fi
  fi
  if min(sbL, sbR) < ln[k]:
    if (dr[k] dotprod dir lit) > 0:
      fill lb -- rb -- (rb - cl*dr[k]) -- (lb - cl*dr[k]) -- cycle
        withcolor shade;
    fi
  fi
enddef;

% 열린 투어의 두 끝에 구슬을 단다. 리본이 끝나는 자리 LL--RR가 구슬의 현이 되도록
% 중심을 앞으로 밀어 두면, 구슬의 큰 호가 리본에 매끄럽게 이어진다.
def capends =
  bead(tv[0], LA[0], RA[0], -dr[0], true);
  bead(tv[tn-1], LB[ne-1], RB[ne-1], dr[ne-1], false);
enddef;

def bead(expr v, pl, pr, out, head) =
  begingroup
    save r, m, ctr, aa, bb, p;
    numeric r, m, aa, bb; pair ctr; path p;
    r := bulb*hw*uu;
    m := r +-+ (hw*uu);                    % sqrt(r^2 - (hw*uu)^2)
    ctr := v + m*out;
    aa := angle(pl - ctr); bb := angle(pr - ctr);
    p := if head: arcpath(ctr, r, aa, bb) else: arcpath(ctr, r, bb, aa) fi;
    fill p -- cycle withcolor pulp;
    if wire > 0:
      if head: drawarc(ctr, r, aa, bb) else: drawarc(ctr, r, bb, aa) fi;
    fi
  endgroup
enddef;
