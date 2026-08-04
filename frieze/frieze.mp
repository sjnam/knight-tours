% frieze.mp — 크누스의 나이트 투어 전시장에 걸린 폭 3칸짜리 띠들.
%
% 두 벌이 들어 있다. 둘 다 폭이 3칸이고 저마다 하나의 닫힌 나이트 투어이며,
% 길이를 매개변수로 받는다.
%
%   lvl_eight_frz (n, vert, grid)   3x(10n+20)   8층 엘리베이터 문 위의 프리즈
%   lvl_three_lft (n, vert, grid)   3x(4n+16)    KTb.jpg의 왼쪽 띠   (사진은 n=3)
%   lvl_three_mid (n, vert, grid)   3x(4n+10)    KTb.jpg의 가운데 띠 (사진은 n=4)
%   lvl_three_rgt (n, vert, grid)   3x(8n+12)    KTb.jpg의 오른쪽 띠 (사진은 n=2)
%
% 인자는 넷 다 같다.
%   n     주기 몇 벌인가. 0 이상.
%   vert  참이면 세로로 세운다. 그리는 좌표는 넷 다 가로로 누운 꼴이라, 참이면
%         90도 돌린다. KTb.jpg의 띠 셋은 벽에 세로로 걸려 있으니 참이 벽 모습이다.
%   grid  참이면 격자와 칸 점을 함께 깐다.
%
% 바탕과 선 빛깔은 옆 방의 ../celtic-tours/ktknot.mp에서 차림새 둘을 빌려다 쓴다.
% paperlook이면 흰 바탕에 검은 가는 선, walllook이면 크누스의 사진 속 벽처럼 어두운
% 타일 위에 흰 굵은 선이다. 그림마다 beginfig 안에서 고른다.
%
% 만드는 법:  mptopdf frieze.mp    -> frieze-1.pdf ... (PDF)
%             mpost   frieze.mp    -> frieze.1 ...     (EPS)
% TeX 라벨은 없다.
%
% ============================================================================
% 8층 문 위의 프리즈 (lvl_eight_frz)
% ============================================================================
% 같은 8층이라도 엘리베이터 {\it 왼쪽 벽\/}에 있는 것은 겹친 액자(nested frames)라
% 이것과 다른 무늬다. 폭은 똑같이 3칸이니 헷갈리지 말 일이다.
%
% 무늬는 크누스가 적어 둔 모티프 `133-122-011-023-131-110-231-223-001-101'을 그의 책
% Selected Papers on Fun and Games 42장 Long and Skinny Knight's Tours(p.514)의
% 규칙으로 풀어 얻었다. 규칙은 3xN 투어를 열 단위로 이어 붙이는 상태 기계로 본다---
% 열을 하나 더 붙일 때 새 열의 세 칸으로 어떤 이음이 들어오는지를 세 자리 수 abc로
% 적고, 자리마다 값이 더해진다:
%
%   a: +1은 (1,j-2)-(0,j),  +2는 (2,j-1)-(0,j)
%   b: +1은 (0,j-2)-(1,j),  +2는 (2,j-2)-(1,j)
%   c: +1은 (0,j-1)-(2,j),  +2는 (1,j-2)-(2,j)
%
% 모티프는 가운데를 채울 뿐이고, 고리를 닫는 양 끝 스무 열은 크누스가 적어 두지
% 않았다. 그래서 같은 규칙 위에서 마감 코드를 탐색해 얻었다. 왼쪽 열 코드는
% `000-201-133-122-011-023-131-311-200-202', 오른쪽은
% `133-122-011-023-033-111-211-002-131-333'이다.
%
% 마감은 이것 하나가 아니다. 좌우 열 열씩으로 끊으면 7744가지가 나오고 그 전부가
% 모든 n에 통한다. 크누스가 어느 것을 썼는지는 사진만으로 가리기 어려워 그중 하나를
% 골랐다. 덧붙여, 이 띠에는 평행이동 말고는 대칭이 없어서(미끄럼반사도 180도 회전도
% 없다) 좌우 마감이 서로 뒤집힌 꼴인 투어는 아예 존재하지 않는다---7744가지를 모두
% 확인했다.
%
% ============================================================================
% 3층의 띠 셋 (lvl_three_lft, lvl_three_mid, lvl_three_rgt)
% ============================================================================
% 원본은 크누스의 사진이다.  https://cs.stanford.edu/~knuth/KTb.jpg
% 벽에 세로로 나란히 걸린 띠 셋인데, 여기 적은 이음은 그 사진에서 픽셀 단위로 읽어
% 낸 것이다. 정면에서 찍혀 원근 왜곡이 없고 배경 타일이 격자 구실을 해서 수월했다.
% 자동상관으로 재니 세 띠 모두 세로 주기가 422px이고 칸 크기는 105.3px이었다. 격자의
% 위상은 눈대중으로 정하지 않고 "모든 칸의 차수가 2가 되는가"를 점수로 삼아 탐색해
% 얻었다---맞는 격자에서만 그 값이 최대가 되기 때문이다.
%
% 검산은 세 겹으로 했다.
%   1. 차수. 246칸이 모두 정확히 차수 2이고, 띠마다 고리가 하나뿐이다.
%   2. 역방향. 사진의 밝은 픽셀 14만 개 가운데 여기 적은 이음으로 설명되지
%      않는 것이 하나도 없다. 빠뜨린 이음이 없다는 뜻이다.
%   3. 분리도. 후보 이음마다 선분을 따라 최저 밝기를 재면, 있는 것은 228~253,
%      없는 것은 18~28이다. 틈이 200을 넘으니 애매한 판정이 하나도 없다.
%
% 읽어 낸 것을 크누스의 열 코드로 되옮기니 주기가 드러나, 길이를 매개변수로 받을 수
% 있게 되었다. 가운데와 오른쪽은 주기를 한 벌만 쓰면 홀짝에 따라 고리가 둘로 갈려서
% (차수는 다 2인데도) 두 벌을 한 주기로 묶었다. 그래서 가운데의 주기가 4열,
% 오른쪽이 8열이다.
%
% 셋은 서로 다른 투어다. 왼쪽과 오른쪽은 크기가 같은데도 뒤집거나 돌려서 포갤 수
% 없다. 가운데가 3x26인 것이 반갑다---크누스가 적어 둔 3x(12n+14)의 n=1이 26이다.

% 바탕은 켈트 매듭 꾸러미의 것을 그대로 빌려 쓴다. paperlook과 walllook이 정해 주는
% 대로 칸이 깔리고 선 빛깔이 정해지니, 이 띠들이 옆 방의 걸개그림과 한 살림이 된다.
% 빌려 쓰는 것은 다섯뿐이다---차림새 둘, 판을 정하는 setboard, 바탕을 까는 backdrop과
% gridboard. 매듭을 짜는 부분은 손대지 않는다. 이 띠들은 리본이 아니라 가는 선
% 하나로 그리는 그림이라서다.
input ../celtic-tours/ktknot;

paperlook;             % 밑값. 그림마다 beginfig 안에서 다시 고른다.
uu := 8;               % 한 칸의 크기

% 이음 하나. 첫 지표가 폭(0..2), 둘째가 길이 방향이다. 행이 아래로 자라야 하니
% y를 뒤집는다. 그래서 그냥 그리면 가로로 눕는다. 켈트 쪽 K와 같은 셈법이라
% 판의 자리도 setboard가 잡아 주는 것과 그대로 맞물린다.
def e(expr ra, ca, rb, cb) =
  draw (ca*uu, -ra*uu)--(cb*uu, -rb*uu);
enddef;

% 무늬를 긋는 펜. 차림새가 정해 준다---종이에서는 검은 가는 선, 벽에서는 흰 굵은 선.
def cordpen = drawoptions(withpen pencircle scaled hairw withcolor hair); enddef;

% 칸마다 찍는 점. 격자 위에 놓이니 선과 같은 빛깔로 찍는다.
def celldots(expr len) =
  for c = 0 upto len-1: for r = 0 upto 2:
    fill fullcircle scaled .15uu shifted (c*uu, -r*uu) withcolor hair;
  endfor endfor
enddef;

% 띠 그림 하나를 매개변수대로 놓는다. 넷이 이것을 함께 쓴다.
%   pp    무늬 그림 (가로로 누운 꼴)
%   len   판의 길이. 격자를 그 길이에 맞춘다.
%   vert  참이면 90도 돌려 세운다.
%   grid  참이면 격자를 함께 깐다.
% 격자를 무늬와 한 그림으로 합친 뒤에 돌리는 것이 요령이다. 따로 그리고 돌리면
% 격자만 제자리에 남는다.
%
% 바탕 띠(backdrop)는 격자를 안 깔 때에도 늘 깐다. 벽 차림새에서는 무늬가 흰 선이라
% 바탕이 없으면 흰 종이에 흰 선이 되어 아무것도 안 보이기 때문이다. 종이 차림새에서는
% 바탕이 흰색이라 깔아도 티가 안 난다.
def showband(expr pp, len, vert, grid) =
  begingroup
    save qq; picture qq;
    drawoptions();   % 무늬를 뜨며 켜 둔 펜을 끈다. 안 그러면 바탕을 덧칠한다.
    qq := image(
      setboard(len, 3);
      backdrop(brim);
      if grid: gridboard; celldots(len); fi
      draw pp;
    );
    draw if vert: qq rotated 90 else: qq fi;
    drawoptions();
  endgroup
enddef;

% ===== 8층 문 위의 프리즈 =====================================================

% 한 주기가 더하는 이음 서른. 주기가 열 칸이고 닫힌 투어는 칸마다 이음이 둘이라
% 이음 수가 곧 칸 수이니 10*3 = 30이다. 열 0..9가 제 몫이고, 10·11열로 삐져나온
% 이음은 다음 주기 자리에서 만난다.
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

% 오른쪽 마감, 스물여섯 이음. 마지막 주기가 끝난 자리를 원점으로 적었다.
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

% 주기 n벌짜리 프리즈. 판은 3x(10n+20)이고 이음은 30n+60 = 3(10n+20)개다.
vardef lvl_eight_frzpic(expr n) =
  save fz; picture fz;
  cordpen;
  fz := image(period);
  image(
    capleft;
    for t = 0 upto n-1: draw fz shifted ((10 + 10t)*uu, 0); endfor
    draw image(capright) shifted (10n*uu, 0);
  )
enddef;

def lvl_eight_frz(expr n, vert, grid) = showband(lvl_eight_frzpic(n), 10n+20, vert, grid); enddef;

% ===== KTb.jpg의 띠 셋 ========================================================

% ----- 왼쪽 띠 --- 3x(4n+16), 이음 12n+48개.
% 벽에 걸린 것은 n=3, 곧 3x28이다.

% 앞 마감. 열 0..7이 제 몫이고 뒤쪽이 첫 주기와 맞물린다.
def leftcap =
  e(0,0, 1,2); e(0,0, 2,1); e(0,1, 1,3);
  e(0,1, 2,0); e(0,2, 1,0); e(0,2, 2,1);
  e(0,3, 1,1); e(0,3, 2,2); e(0,4, 1,6);
  e(0,4, 2,5); e(0,5, 1,3); e(0,5, 2,4);
  e(0,6, 1,4); e(0,6, 2,7); e(0,7, 2,6);
  e(1,0, 2,2); e(1,1, 2,3); e(1,2, 2,0);
  e(1,4, 2,6); e(1,5, 2,3); e(1,5, 2,7);
  e(1,6, 2,4); e(1,7, 2,5);
enddef;

% 주기 4열, 이음 12개 (= 4*3, 여기서도 E=V다).
def leftper =
  e(0,-1, 1,1); e(0,0, 1,2); e(0,0, 2,1);
  e(0,1, 1,-1); e(0,1, 2,0); e(0,2, 1,0);
  e(0,2, 2,3); e(0,3, 2,2); e(1,0, 2,2);
  e(1,1, 2,3); e(1,2, 2,0); e(1,3, 2,1);
enddef;

% 뒤 마감. 마지막 주기가 끝난 자리를 원점으로 적었다.
def leftend =
  e(0,-1, 1,1); e(0,0, 1,2); e(0,0, 2,1);
  e(0,1, 1,-1); e(0,1, 2,0); e(0,2, 1,0);
  e(0,2, 2,3); e(0,3, 1,1); e(0,3, 2,4);
  e(0,4, 1,6); e(0,4, 2,3); e(0,5, 1,3);
  e(0,5, 1,7); e(0,6, 2,5); e(0,6, 2,7);
  e(0,7, 1,5); e(0,7, 2,6); e(1,0, 2,2);
  e(1,2, 2,0); e(1,3, 2,1); e(1,4, 2,2);
  e(1,4, 2,6); e(1,5, 2,7); e(1,6, 2,4);
  e(1,7, 2,5);
enddef;

vardef leftpic(expr n) =
  save pp; picture pp;
  cordpen; pp := image(leftper);
  image(
    leftcap;
    for t = 0 upto n-1: draw pp shifted ((8 + 4t)*uu, 0); endfor
    draw image(leftend) shifted ((8 + 4n)*uu, 0);
  )
enddef;

def lvl_three_lft(expr n, vert, grid) = showband(leftpic(n), 4n+16, vert, grid); enddef;

% ----- 가운데 띠 --- 3x(4n+10), 이음 12n+30개.
% 벽에 걸린 것은 n=4, 곧 3x26이다.

% 앞 마감. 열 0..5이 제 몫이고 뒤쪽이 첫 주기와 맞물린다.
def midcap =
  e(0,0, 1,2); e(0,0, 2,1); e(0,1, 1,3);
  e(0,1, 2,0); e(0,2, 1,0); e(0,2, 2,1);
  e(0,3, 1,1); e(0,3, 1,5); e(0,4, 2,3);
  e(0,4, 2,5); e(0,5, 1,3); e(0,5, 2,4);
  e(1,0, 2,2); e(1,1, 2,3); e(1,2, 2,0);
  e(1,4, 2,2);
enddef;

% 주기 4열, 이음 12개 (= 4*3, 여기서도 E=V다).
def midper =
  e(0,0, 1,-2); e(0,0, 2,1); e(0,1, 1,-1);
  e(0,1, 2,0); e(0,2, 1,0); e(0,2, 2,3);
  e(0,3, 1,1); e(0,3, 2,2); e(1,0, 2,-2);
  e(1,1, 2,-1); e(1,2, 2,0); e(1,3, 2,1);
enddef;

% 뒤 마감. 마지막 주기가 끝난 자리를 원점으로 적었다.
def midend =
  e(0,0, 1,2); e(0,0, 2,-1); e(0,1, 1,-1);
  e(0,1, 1,3); e(0,2, 2,1); e(0,2, 2,3);
  e(0,3, 1,1); e(0,3, 2,2); e(1,-2, 2,0);
  e(1,0, 2,-2); e(1,0, 2,2); e(1,1, 2,3);
  e(1,2, 2,0); e(1,3, 2,1);
enddef;

vardef midpic(expr n) =
  save pp; picture pp;
  cordpen; pp := image(midper);
  image(
    midcap;
    for t = 0 upto n-1: draw pp shifted ((6 + 4t)*uu, 0); endfor
    draw image(midend) shifted ((6 + 4n)*uu, 0);
  )
enddef;

def lvl_three_mid(expr n, vert, grid) = showband(midpic(n), 4n+10, vert, grid); enddef;

% ----- 오른쪽 띠 --- 3x(8n+12), 이음 24n+36개.
% 벽에 걸린 것은 n=2, 곧 3x28이다.

% 앞 마감. 열 0..8이 제 몫이고 뒤쪽이 첫 주기와 맞물린다.
def rightcap =
  e(0,0, 1,2); e(0,0, 2,1); e(0,1, 1,3);
  e(0,1, 2,0); e(0,2, 1,0); e(0,2, 2,1);
  e(0,3, 1,1); e(0,3, 2,4); e(0,4, 2,3);
  e(0,4, 2,5); e(0,5, 1,3); e(0,5, 1,7);
  e(0,6, 1,8); e(0,6, 2,5); e(0,7, 1,5);
  e(0,7, 2,6); e(0,8, 2,7); e(1,0, 2,2);
  e(1,1, 2,3); e(1,2, 2,0); e(1,4, 2,2);
  e(1,4, 2,6); e(1,5, 2,7); e(1,6, 2,4);
  e(1,6, 2,8);
enddef;

% 주기 8열, 이음 24개 (= 8*3, 여기서도 E=V다).
def rightper =
  e(0,-1, 2,0); e(0,0, 1,-2); e(0,0, 1,2);
  e(0,1, 1,3); e(0,1, 2,0); e(0,2, 1,0);
  e(0,2, 2,1); e(0,3, 2,2); e(0,3, 2,4);
  e(0,4, 1,2); e(0,4, 1,6); e(0,5, 1,7);
  e(0,5, 2,4); e(0,6, 1,4); e(0,6, 2,5);
  e(0,7, 2,6); e(1,-1, 2,1); e(1,0, 2,2);
  e(1,1, 2,-1); e(1,1, 2,3); e(1,3, 2,5);
  e(1,4, 2,6); e(1,5, 2,3); e(1,5, 2,7);
enddef;

% 뒤 마감. 마지막 주기가 끝난 자리를 원점으로 적었다.
def rightend =
  e(0,-1, 1,1); e(0,0, 1,-2); e(0,0, 1,2);
  e(0,1, 2,0); e(0,1, 2,2); e(0,2, 1,0);
  e(0,2, 2,1); e(1,-1, 2,1); e(1,0, 2,2);
  e(1,1, 2,-1); e(1,2, 2,0);
enddef;

vardef rightpic(expr n) =
  save pp; picture pp;
  cordpen; pp := image(rightper);
  image(
    rightcap;
    for t = 0 upto n-1: draw pp shifted ((9 + 8t)*uu, 0); endfor
    draw image(rightend) shifted ((9 + 8n)*uu, 0);
  )
enddef;

def lvl_three_rgt(expr n, vert, grid) = showband(rightpic(n), 8n+12, vert, grid); enddef;

% 사진처럼 셋을 나란히 세운다. 벽에 걸린 크기 그대로다.
def allthree =
  begingroup save qq; picture qq;
    lvl_three_lft(3, true, false);
    qq := image(lvl_three_mid(4, true, false));   draw qq shifted (6uu, -uu);
    qq := image(lvl_three_rgt(2, true, false)); draw qq shifted (12uu, 0);
  endgroup
enddef;

% 아홉 그림을 두 차림새로 뽑는다. 1~9가 종이, 11~19가 벽이고 번호의 일의 자리가 서로
% 같다---1과 11이 같은 그림, 9와 19가 같은 그림이다. 벽 쪽은 uu를 조금 키웠다. 한 칸이
% 8bp면 타일 사이 틈이 1.4bp밖에 안 되어 칸이 뭉개져 보인다.
%
% 차림새를 먼저 부르고 uu를 나중에 정해야 한다. 차림새는 uu를 건드리지 않지만 brim은
% 다시 정하니, 여백 띠를 손보려면 그것도 차림새 뒤에 두어야 한다.

% ----- 종이 -----
% 8층 프리즈 --- 네 조합.
beginfig(1); paperlook; uu := 8; lvl_eight_frz(2, false, false); endfig;
beginfig(2); paperlook; uu := 8; lvl_eight_frz(2, true,  false); endfig;
beginfig(3); paperlook; uu := 8; lvl_eight_frz(2, false, true ); endfig;
beginfig(4); paperlook; uu := 8; lvl_eight_frz(2, true,  true ); endfig;

% 3층의 띠 셋 --- 벽에 걸린 크기.
beginfig(5); paperlook; uu := 8; allthree; endfig;
beginfig(6); paperlook; uu := 8; lvl_three_lft(3, true, false); endfig;
beginfig(7); paperlook; uu := 8; lvl_three_mid(4, true, false); endfig;
beginfig(8); paperlook; uu := 8; lvl_three_rgt(2, true, false); endfig;
beginfig(9); paperlook; uu := 8; lvl_three_lft(3, false, true); endfig;

% ----- 벽 -----
beginfig(11); walllook; uu := 12; lvl_eight_frz(2, false, false); endfig;
beginfig(12); walllook; uu := 12; lvl_eight_frz(2, true,  false); endfig;
beginfig(13); walllook; uu := 12; lvl_eight_frz(2, false, true ); endfig;
beginfig(14); walllook; uu := 12; lvl_eight_frz(2, true,  true ); endfig;

beginfig(15); walllook; uu := 12; allthree; endfig;
beginfig(16); walllook; uu := 12; lvl_three_lft(3, true, false); endfig;
beginfig(17); walllook; uu := 12; lvl_three_mid(4, true, false); endfig;
beginfig(18); walllook; uu := 12; lvl_three_rgt(2, true, false); endfig;
beginfig(19); walllook; uu := 12; lvl_three_lft(3, false, true); endfig;

end.
