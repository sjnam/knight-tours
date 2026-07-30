# knight-frame

크누스(Donald E. Knuth)의 [나이트 투어 전시장](https://cs.stanford.edu/~knuth/knights.html)
맨 마지막 그림([KTf](https://cs.stanford.edu/~knuth/KTf.jpg))에 나오는 액자 무늬를
**임의 크기의 직사각형으로 다시 지어 주는** 프로그램입니다.

원래 그림은 정사각 테두리였지만, 여기서는 여섯 꼭짓점 별이 촘촘히 맞물린 그 별무늬를
그대로 쓰면서 세로가 긴 A4 비율 등 원하는 크기로 구부립니다. 그리고 결과는 단순한
장식 무늬가 아니라 **폭 3칸 테두리를 한 붓에 도는 진짜 하나의 닫힌 나이트 투어**입니다.

프로그램은 [GWEB](https://github.com/sjnam/gweb) 문학적 프로그래밍으로 작성되어 있어,
[frame.w](frame.w) 한 파일이 Go 소스와 해설 문서를 겸합니다. 문서의 **모든 페이지**가
이 프로그램이 지은 액자로 둘려 있습니다.

## 필요한 것

| 도구 | 용도 |
| --- | --- |
| Go 1.26 이상 | `frame.go` 실행 |
| GWEB (`gtangle`, `gweave`) | `.w`에서 Go 소스와 TeX 문서를 뽑아냄 |
| TeX Live (`mptopdf`, `luatex`) | MetaPost 그림과 문서 조판 |
| `kotexgweb`, `pic.tex` | 한글 GWEB 매크로와 그림 삽입 매크로 |
| Noto CJK 폰트 | 한글 조판 |

## 빌드

```sh
make doc     # gtangle → go run → mptopdf → gweave → luatex
make clean   # 생성물 제거
```

문서 [frame.pdf](frame.pdf)(16쪽)와 액자 그림 `frame-1.pdf`(세로),
`frame-2.pdf`(가로)가 나옵니다.

## 사용법

```sh
go run frame.go            # 기본값 103×73 (A4 비율)
go run frame.go 121 85     # 원하는 크기로
```

두 방향(세로·가로)을 늘 함께 내므로 두 인자의 순서는 결과를 바꾸지 않습니다. 큰 쪽이
세로, 작은 쪽이 가로가 됩니다.

**각 변은 13 이상이면서 6으로 나눈 나머지가 1이어야 합니다.** 별무늬의 주기가 여섯
칸이고 네 모서리 매듭이 자리를 차지하기 때문에, 이 조건이 맞지 않으면 네 고리가 하나로
이어지지 않습니다. 조건에 어긋나면 프로그램이 그 자리에서 멈춥니다.

실행하면 `framedef.mp`가 만들어지고, 지은 액자가 정말 하나의 닫힌 투어인지 검증한 결과를
알려줍니다.

```text
세로 액자: 103×73, 간선 1020개, 하나의 닫힌 나이트 투어 ✓
가로 액자: 73×103, 간선 1020개, 하나의 닫힌 나이트 투어 ✓
```

## 다른 문서에서 액자 쓰기

`frame.go`가 내놓는 것은 **`framedef.mp`** 하나이고, 여기에는 매크로 정의만 들어 있습니다.
그것을 들여와 기본 흑백으로 그리는 다섯 줄짜리 드라이버 `frame.mp`은 생성물이 아니라
저장소에 함께 있는 소스 파일입니다.

```metapost
def frameV(expr line, bg, pw)   % 세로
def frameH(expr line, bg, pw)   % 가로
```

선 색(`line`)·배경색(`bg`)·선 굵기(`pw`)를 입력으로 받으므로, `framedef.mp`를 들여오면
액자를 원하는 모양으로 다시 쓸 수 있습니다.

들여올 대상은 `frame.mp`이 아니라 **`framedef.mp`**입니다. `frame.mp`은 맨 끝이 `end.`인데
이는 MetaPost의 실행을 그 자리에서 끝내므로, 그것을 `input`하면 기본 흑백 그림 둘이 나온 뒤
호출자의 `beginfig`가 돌지 못합니다. `framedef.mp`에는 `end.`가 없어 그럴 일이 없습니다.

### 색 지정

MetaPost 이름 색, RGB 3원소, CMYK 4원소를 모두 그대로 넘길 수 있습니다. `expr`
매개변수라 색 타입을 가리지 않습니다.

```metapost
input framedef;

% 이름 색
beginfig(1); frameH(0.6red, 0.95white, 0.3pt); endfig;

% RGB — 원소가 셋이면 rgbcolor
beginfig(2); frameV((0.2,0.35,0.75), (0.97,0.97,1.0), 0.4pt); endfig;

% CMYK — 원소가 넷이면 cmykcolor
beginfig(3); frameV((0,0.85,0.85,0.10), (0,0,0.05,0), 0.4pt); endfig;

end.
```

`mptopdf`를 거치면 RGB는 PDF의 `rg`, CMYK는 `k` 연산자로 그대로 나갑니다. 인쇄용 CMYK
원고에 섞어도 색이 RGB로 바뀌지 않습니다.

### 페이지 배경으로 깔기

문서의 모든 페이지에 깔려면 `frame.w`의 limbo가 하는 것처럼 `\plainoutput`을 다시
정의해 배경 그림을 얹습니다. 색인은 2단 조판이라 `\plainoutput`을 타지 않으므로,
gwebmac의 `\coloutput`도 함께 손봐야 색인 페이지까지 둘립니다.

## 짓는 원리

1. 크누스의 그림에서 이음(간선)을 픽셀 단위로 읽어 냈습니다. 곧은 변의 주기 6 마디는
   열여덟 개의 이음(`knuthMod`), 모서리를 도는 매듭은 서른 개의 이음(`knuthCorner`)
   입니다. 이 둘이 액자의 재료입니다.
2. 네 변에 마디를 여섯 칸씩 이어 깔고 네 모서리에 매듭을 얹으면 모든 칸이 degree 2가
   되지만, 변마다 고리 하나씩 **네 개의 닫힌 고리**로 갈립니다.
3. 이웃한 두 고리를 **2-opt**로 세 번 이어 붙여 하나로 만듭니다. 이음 둘을 떼고 엇갈려
   다시 잇는 맞바꿈인데, 후보 중 모서리에 가장 가까운 것을 골라야 별무늬 속에 자연스레
   묻힙니다. 크누스가 정사각 액자에서 쓴 바로 그 요령입니다.
4. 다 짓고 나서 고리를 따라 걸으며(`loopID`) 고리가 하나뿐인지, 이음 수가
   `6(Nh+Nw)-36`인지 확인합니다. 모든 칸이 degree 2이므로 이 값은 테두리의 칸 수와
   같습니다.

## 파일

| 파일 | 설명 |
| --- | --- |
| [frame.w](frame.w) | GWEB 원본. Go 소스와 해설 문서를 겸함 |
| [Makefile](Makefile) | 빌드 |
| `myframe.pdf` | 문서의 페이지 배경으로 쓰는 세로 액자 |
| [frame.mp](frame.mp) | 매크로를 기본 흑백으로 불러 그리는 드라이버. 손으로 쓴 소스 |
| `framedef.mp` | 생성물. 액자 매크로 정의. 다른 문서가 들여오는 파일 |
| `frame.go`, `frame-*.pdf`, `frame.tex`, `frame.pdf` | 생성물 (`make clean` 대상) |

`myframe.pdf`는 기본 크기·기본 색으로 뽑은 `frame-1.pdf`를 따로 갈무리해 둔 것입니다.
`make clean`이 지우지 않으므로 생성물을 다 치운 상태에서도 문서가 조판됩니다. 다만
`\FrameBG`가 가리키는 대상이 `frame-1.pdf`가 아니라 이 파일이므로, 크기나 색을 바꿔 다시
지었다면 새 `frame-1.pdf`를 `myframe.pdf`로 덮어써야 페이지 테두리에 반영됩니다.
