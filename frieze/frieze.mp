% frieze.mp — 크누스의 나이트 투어 전시장 8층, 엘리베이터 {\it 문 위\/}의 프리즈.
%
% 같은 8층이라도 엘리베이터 {\it 왼쪽 벽\/}에 있는 것은 겹친 액자(nested frames)라
% 이것과 다른 무늬다. 폭은 똑같이 3칸이니 헷갈리지 말 일이다.
%
% 이 파일은 홀로 선다---바깥에서 input하는 것도, TeX 라벨도 없다.
%
% frieze(n)은 3x(10n+20) 판을 한 붓에 도는 {\it 진짜 닫힌 나이트 투어\/}를 그린다.
% 크누스가 적어 둔 "n copies of the motif will give a 3x(10n+20) cycle" 그대로다.
%
% 만드는 법:  mptopdf frieze.mp    -> frieze-1.pdf ... (PDF)
%             mpost   frieze.mp    -> frieze.1 ...     (EPS)
%
% --- 무늬는 어디서 왔나 -------------------------------------------------------
% 크누스는 모티프 `133-122-011-023-131-110-231-223-001-101'만 적어 두었다. 그의 책
% Selected Papers on Fun and Games 42장 Long and Skinny Knight's Tours(p.514)는
% 3xN 투어를 열 단위로 이어 붙이는 상태 기계로 본다---열을 하나 더 붙일 때 새 열의
% 세 칸으로 어떤 이음이 들어오는지를 세 자리 수 abc로 적고, 자리마다 값이 더해진다:
%
%   a: +1은 (1,j-2)-(0,j),  +2는 (2,j-1)-(0,j)
%   b: +1은 (0,j-2)-(1,j),  +2는 (2,j-2)-(1,j)
%   c: +1은 (0,j-1)-(2,j),  +2는 (1,j-2)-(2,j)
%
% 같은 규칙으로 4층 모티프 `011-223-110-212-131-222'를 풀면 크누스의 그림에서 읽어 낸
% 4층 프리즈 한 마디가 글자 하나 다르지 않게 나온다. 그러니 아래 period도 믿을 만하다.
%
% --- 양 끝의 마감은 내가 찾았다 -----------------------------------------------
% 모티프는 가운데를 채울 뿐이고, 고리를 닫는 양 끝 스무 열은 크누스가 적어 두지
% 않았다. 그래서 같은 규칙 위에서 마감 코드를 탐색해 얻었다. 왼쪽 열 코드는
% `000-201-133-122-011-023-131-311-200-202', 오른쪽은
% `133-122-011-023-033-111-211-002-131-333'이다. 이 한 벌이 n=1,2,3,4 어디서나
% 하나의 닫힌 고리를 이루는 것을 확인했다(그래서 frieze가 n을 받을 수 있다).
%
% 마감은 이것 하나가 아니다. 좌우 열 열씩으로 끊으면 7744가지가 나오고 그 전부가
% 모든 n에 통한다. 크누스가 어느 것을 썼는지는 사진만으로 가리기 어려워 그중 하나를
% 골랐다. 덧붙여, 이 띠에는 평행이동 말고는 대칭이 없어서(미끄럼반사도 180도 회전도
% 없다) 좌우 마감이 서로 뒤집힌 꼴인 투어는 아예 존재하지 않는다---7744가지를 모두
% 확인했다.

numeric uu; uu := 8;   % 한 칸의 크기

% 이음 하나. 행이 아래로 자라야 하니 y를 뒤집는다.
def e(expr ra, ca, rb, cb) =
  draw (ca*uu, -ra*uu)--(cb*uu, -rb*uu);
enddef;

def blackpen = drawoptions(withpen pencircle scaled .5pt); enddef;

% 폭 3칸 띠의 격자를 그림으로 뜨고 칸마다 점을 찍는다. 판이 10n+20열이니 마지막 열
% 번호는 10n+19다. 무늬와 함께 돌려야 하므로 따로 그리지 않고 그림으로 돌려준다.
vardef gridpic(expr n) =
  save maxc; numeric maxc; maxc := 10n + 19;
  image(
    drawoptions(withpen pencircle scaled .3pt withcolor .75white);
    for r = 0 upto 2: for c = 0 upto maxc:
      draw unitsquare scaled uu shifted ((c-.5)*uu, (-r-.5)*uu);
    endfor endfor
    drawoptions();
    for r = 0 upto 2: for c = 0 upto maxc:
      fill fullcircle scaled 1.2 shifted (c*uu, -r*uu);
    endfor endfor
  )
enddef;

% 한 주기가 더하는 이음 서른. 주기가 열 칸이고 닫힌 투어는 칸마다 이음이 둘이라
% 이음 수가 곧 칸 수이니 10*3 = 30이다. 열 0..9가 제 몫이고, 10·11열로 삐져나온
% 이음은 다음 주기 자리에서 만난다(frame.mp의 modul이 6·7열로 삐져나오는 것과 같다).
% 이름에 숫자를 붙이면 안 된다---MetaPost가 배열 첨자로 읽는다.
def period =
  e(0,0, 1,2); e(0,1, 2,2); e(1,1, 2,3);
  e(0,2, 2,3); e(0,2, 1,4); e(0,3, 2,4);
  e(0,3, 1,5); e(1,3, 2,1); e(0,4, 1,2);
  e(0,4, 1,6); e(1,4, 2,2); e(0,5, 1,3);
  e(0,5, 2,6); e(1,5, 2,7); e(0,6, 2,5);
  e(0,6, 2,7); e(1,6, 2,4); e(0,7, 2,6);
  e(0,7, 2,8); e(1,7, 2,5); e(0,8, 2,9);
  e(0,8, 1,10); e(1,8, 2,10); e(0,9, 1,7);
  e(0,9, 2,10); e(1,9, 2,11); e(0,10, 1,8);
  e(1,10, 2,8); e(0,11, 1,9); e(1,11, 2,9);
enddef;

% 왼쪽 마감, 서른네 이음. 열 0..11을 쓰며 뒤쪽 두 열이 첫 주기와 맞물린다.
def capleft =
  e(0,0, 2,1); e(0,0, 1,2); e(1,0, 2,2);
  e(1,0, 0,2); e(2,0, 0,1); e(2,0, 1,2);
  e(0,1, 2,2); e(1,1, 2,3); e(1,1, 0,3);
  e(2,1, 1,3); e(0,2, 1,4); e(0,3, 2,4);
  e(1,3, 2,5); e(2,3, 1,5); e(0,4, 2,5);
  e(0,4, 1,6); e(1,4, 0,6); e(2,4, 1,6);
  e(0,5, 2,6); e(0,5, 1,7); e(1,5, 0,7);
  e(0,6, 2,7); e(2,6, 0,7); e(1,7, 2,9);
  e(2,7, 0,8); e(0,8, 1,10); e(1,8, 0,10);
  e(1,8, 2,10); e(2,8, 1,10); e(2,8, 0,9);
  e(0,9, 2,10); e(1,9, 0,11); e(1,9, 2,11);
  e(2,9, 1,11);
enddef;

% 오른쪽 마감, 스물여섯 이음. 마지막 주기가 끝난 자리를 원점으로 적었으므로
% frieze가 10n만큼 옮겨 놓는다. 앞쪽 두 열이 마지막 주기와 맞물린다.
def capright =
  e(0,10, 1,12); e(0,11, 2,12); e(1,11, 2,13);
  e(2,11, 1,13); e(0,12, 2,13); e(0,12, 1,14);
  e(1,12, 2,14); e(2,12, 1,14); e(0,13, 2,14);
  e(0,13, 1,15); e(1,13, 0,15); e(0,14, 1,16);
  e(0,14, 2,15); e(0,15, 2,16); e(1,15, 2,17);
  e(2,15, 0,16); e(0,16, 1,18); e(1,16, 0,18);
  e(2,16, 1,18); e(0,17, 1,19); e(0,17, 2,18);
  e(1,17, 0,19); e(1,17, 2,19); e(2,17, 1,19);
  e(0,18, 2,19); e(2,18, 0,19);
enddef;

% 주기 n벌짜리 프리즈를 그림 하나로 뜬다. 가로로 누운 꼴이고 왼쪽 위가 칸 (0,0)이다.
% 판은 3x(10n+20)이고 이음은 30n+60 = 3(10n+20)개---닫힌 투어는 칸마다 이음이 둘이라
% 이음 수가 곧 칸 수다. 주기 하나를 미리 떠 두었다가 열 칸씩 옮겨 찍으므로 n이 커져도
% 표는 한 번만 읽는다.
vardef friezepic(expr n) =
  save fz; picture fz;
  blackpen;
  fz := image(period);
  image(
    capleft;
    for t = 0 upto n-1: draw fz shifted ((10 + 10t)*uu, 0); endfor
    draw image(capright) shifted (10n*uu, 0);
  )
enddef;

% 가로로 누운 프리즈. 폭 3칸에 길이 10n+20칸.
def frieze(expr n) =
  draw friezepic(n);
  drawoptions();
enddef;

% 세로로 선 프리즈. 가로짜리를 90도 돌린 것이라 무늬도 이음 수도 똑같다.
def friezevert(expr n) =
  draw friezepic(n) rotated 90;
  drawoptions();
enddef;

% 격자를 깐 것도 한 그림으로 뜬다. 그래야 돌릴 때 격자와 무늬가 함께 돌아간다.
vardef friezegridpic(expr n) =
  image(
    draw gridpic(n);
    draw friezepic(n);
  )
enddef;

% 격자까지 함께 --- 가로.
def friezewithgrid(expr n) =
  draw friezegridpic(n);
  drawoptions();
enddef;

% 격자까지 함께 --- 세로.
def friezevertwithgrid(expr n) =
  draw friezegridpic(n) rotated 90;
  drawoptions();
enddef;

beginfig(1);
  frieze(2);
endfig;

beginfig(2);
  friezevert(2);
endfig;

beginfig(3);
  friezewithgrid(2);
endfig;

beginfig(4);
  friezevertwithgrid(2);
endfig;

end.
