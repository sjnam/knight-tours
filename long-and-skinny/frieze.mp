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
%   grid  참이면 격자와 칸을 함께 깐다.
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
%
% 이 셋을 벽까지 곁들여 사진 그대로 세운 것이 맨 끝의 20번 그림이다. 잰 값과 벽
% 얼룩을 흉내 내는 법은 거기 적어 두었다.

% 바탕은 켈트 매듭 꾸러미의 것을 그대로 빌려 쓴다. paperlook과 walllook이 정해 주는
% 대로 칸이 깔리고 선 빛깔이 정해지니, 이 띠들이 옆 방의 걸개그림과 한 살림이 된다.
% 빌려 쓰는 것은 다섯뿐이다---차림새 둘, 판을 정하는 setboard, 바탕을 까는 backdrop과
% gridboard. 매듭을 짜는 부분은 손대지 않는다. 이 띠들은 리본이 아니라 가는 선
% 하나로 그리는 그림이라서다.
input ../celtic/ktknot;

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
      if grid: gridboard; fi
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
% 8bp면 타일 사이 틈이 1.4bp밖에 안 되어 칸이 뭉개져 보인다. 사진 KTb.jpg를 통째로
% 흉내 낸 20번이 그 뒤에 하나 더 붙는다.
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

% ============================================================================
% 사진 통째로 --- KTb.jpg
% ============================================================================
% 위의 allthree는 띠 셋을 나란히 세우기만 한 것이라 사이가 넉넉하다. 여기서는
% 사진 https://cs.stanford.edu/~knuth/KTb.jpg를 통째로 흉내 낸다. 걸린 자리도
% 벽까지도 사진에서 잰 대로다. 잰 것을 적어 둔다.
%
%   걸개 한 칸        105.5화소
%   벽 타일 한 칸      52.8화소  --- 걸개 칸의 꼭 반이다
%   걸개 타일 사이 틈    9화소 = 한 칸의 0.085
%   타일 테두리        두께 2화소, 밝기 255분의 67
%   타일 네 귀         모나다 --- 여덟 배로 늘여도 각이 그대로다(KTg.jpg는 둥글었다)
%   끈                두께 3.0화소 = 한 칸의 0.028, 봉우리 밝기 255분의 245
%   걸개 타일          체스판처럼 번갈아 255분의 20과 35
%   벽 바탕            255분의 18
%   밝은 벽 타일       255분의 37
%
% 벽 타일이 걸개 칸의 반이라는 것이 이 사진의 열쇠다. 그 덕에 띠 셋이 서로 반 칸씩
% 어긋나 걸릴 수 있다. 벽칸으로 세면 왼쪽 띠가 0~5열, 가운데가 7~12열, 오른쪽이
% 14~19열이라 사이가 꼭 한 벽칸씩이다. 세로로는 왼쪽과 오른쪽이 0~55행(28걸개칸),
% 가운데가 2~53행(26걸개칸)이니 가운데가 위아래로 한 걸개칸씩 들어와 있다.
% 격자 자리는 밝은 테두리가 세로줄·가로줄 평균에서 뾰족한 봉우리로 드러나 화소
% 단위로 읽었다. 세로 봉우리 열여덟이 모두 52.8화소 격자에 0.5화소 안으로 맞았다.
%
% 벽 얼룩은 KTg.jpg의 것과 딴판이다. 거기서는 걸개에서 멀어질수록 어두워지는
% 연속 분포였는데 여기서는 값이 둘뿐이다. 걸개를 밟지 않는 벽칸 292개를 재니
% 밝은 것 181개와 어두운 것 111개로 딱 갈리고 그 사이가 텅 비어 있다. 그래서
% 밝을 확률 0.64로 칸마다 동전을 던진다. 이웃끼리 같을 확률은 0.62로 나왔는데
% 그냥 던지기만 해도 0.54가 나오니(표본 110에 표준편차 0.05) 뭉침의 증거로는
% 약하다. KTg 쪽 2x2 묶음을 여기 들여오지 않은 까닭이다.
%
% 다만 이웃한 밝은 칸 둘은 사진에서 틈 없이 한 덩이가 된다. 가로줄 하나를 훑으면
% 밝은 자리 36화소와 틈 17화소가 되풀이되다가, 두 칸이 잇달아 밝은 데서는 88화소
% 짜리 한 덩이가 되고 가운데 틈이 없다. 그래서 타일마다 네 변을 따로 보아 이웃이
% 어두울 때만 그쪽으로 틈만큼 물러난다.

numeric wallcols; wallcols := 20;   % 벽의 크기 (벽칸)
numeric wallrows; wallrows := 56;
numeric wcell;                      % 벽 타일 한 칸. 걸개 칸의 반이다.
numeric wseam;  wseam := .32;       % 벽 타일 사이 틈 (벽칸 단위)
numeric lite;   lite  := .64;       % 밝은 벽 타일이 될 확률
color wtile;    wtile := .145white;

% 밝은 칸인가. 지표는 둘씩 밀어 놓았다---칸 -1..wallcols를 그리는데 이웃을 물으려면
% 그 바깥 한 겹까지 있어야 해서다. 바깥 겹도 던져 둔다. 그리지는 않지만 가장자리
% 칸이 밖으로 이어지는지를 그것이 정한다. 사진의 벽도 사진 밖으로 이어지니 맞다.
boolean wl[][];
def scatter =
  for i = 0 upto wallcols+3: for j = 0 upto wallrows+3:
    wl[i][j] := (uniformdeviate 1 < lite);
  endfor endfor
enddef;

% 밝은 벽 타일 하나. 걸개 위의 타일과 달리 밝은 테두리가 없다---사진이 그렇다.
def wspot(expr i, j) =
  begingroup save a, b, c, e; numeric a, b, c, e;
    a := (i - .5)*wcell; b := (i + .5)*wcell;
    c := (-j - .5)*wcell; e := (-j + .5)*wcell;
    if not wl[i+1][j+2]: a := a + .5wseam*wcell; fi
    if not wl[i+3][j+2]: b := b - .5wseam*wcell; fi
    if not wl[i+2][j+3]: c := c + .5wseam*wcell; fi
    if not wl[i+2][j+1]: e := e - .5wseam*wcell; fi
    fill (a,c) -- (b,c) -- (b,e) -- (a,e) -- cycle withcolor wtile;
  endgroup
enddef;

% 걸개가 차지하는 벽칸을 적어 둔다. 얼룩은 그 자리를 건너뛴다. 걸개 타일 사이에는
% 틈이 있어서 얼룩을 먼저 뿌리고 덮으면 그 틈으로 얼룩이 비친다.
numeric np; np := 0;
numeric px[], py[], qx[], qy[];
def claim(expr X, Y, nc, nr) =
  px[np] := X; py[np] := Y; qx[np] := X + nc - 1; qy[np] := Y + nr - 1;
  np := np + 1;
enddef;
vardef covered(expr x, y) =
  save k, b; numeric k; boolean b; b := false;
  for k = 0 upto np-1:
    if (x >= px[k]) and (x <= qx[k]) and (y >= py[k]) and (y <= qy[k]):
      b := true;
    fi
  endfor
  b
enddef;

% 띠 하나를 벽칸 (X,Y)를 왼쪽 위로 삼아 건다. showband과 달리 바탕을 깔지 않는다---
% 바탕은 벽이 통째로 한 번만 깔기 때문이다. 세운 그림은 x로 -1..5벽칸, y로 -1..
% (2len-1)벽칸을 차지하니 그만큼 옮기면 제자리에 온다.
def hangband(expr pp, len, X, Y) =
  begingroup
    save qq; picture qq;
    drawoptions();
    qq := image(setboard(len, 3); gridboard; draw pp;);
    draw (qq rotated 90) shifted ((X + .5)*wcell, -(Y + 2len - 1.5)*wcell);
    drawoptions();
  endgroup
enddef;

% 그리는 차례는 벽 바탕, 얼룩, 띠 셋이다. 난수는 randomseed를 박아 다시 그려도 같은
% 무늬가 나오게 했다. 여백은 둘레로 한 벽칸씩 두었다---사진은 반 칸쯤에서 잘렸는데,
% 반 칸으로 두면 가장자리 타일이 잘려 나가 어수선해 보인다.
beginfig(20);
  walllook; drawoptions();
  uu := 24bp; wcell := .5uu;
  seam := .085; bevel := 0; rim := .019uu; mesh := .26white;
  tilea := .078white; tileb := .137white;
  hairw := .0285uu;
  randomseed := 3184;

  np := 0;
  claim(0, 0, 6, 56); claim(7, 2, 6, 52); claim(14, 0, 6, 56);

  fill (-1.5wcell, 1.5wcell) -- ((wallcols + .5)*wcell, 1.5wcell)
    -- ((wallcols + .5)*wcell, -(wallrows + .5)*wcell)
    -- (-1.5wcell, -(wallrows + .5)*wcell) -- cycle withcolor slab;

  scatter;
  for i = -1 upto wallcols: for j = -1 upto wallrows:
    if wl[i+2][j+2] and not covered(i,j): wspot(i, j); fi
  endfor endfor

  hangband(leftpic(3),  28,  0, 0);
  hangband(midpic(4),   26,  7, 2);
  hangband(rightpic(2), 28, 14, 0);
endfig;

end.
