# ktf — 크누스의 겹친 액자

크누스(Donald E. Knuth)의 [나이트 투어 전시장](https://cs.stanford.edu/~knuth/knights.html)
맨 마지막 그림([KTf](https://cs.stanford.edu/~knuth/KTf.jpg))에 있는 **겹친 액자**를
그림에서 간선 단위로 읽어 되살린 것입니다. 크누스는 이렇게 적었습니다.

> The wall to the left of the elevator on level 8 completes the exhibit by
> illustrating a brand-new kind of knight's tour, not previously studied: A set of
> *nested frames*, each only three cells wide. Here we see a 7×7 frame inside a
> 31×31 frame inside a 55×55 frame. Each larger frame is obtained from the
> next-smaller one by inserting four of the modules that were used in the frieze on
> level 4. For several days I feared that such tours would be impossible; but
> suddenly everything clicked into place.

세 액자는 저마다 폭 3칸 사각 테두리를 한 붓에 도는 진짜 닫힌 나이트 투어입니다. 이
프로그램은 그것을 되살려 **정말 그러한지 검증하고**, 세 투어를 한 중심에 겹쳐 그립니다.
겹을 구분하려고 바깥 55×55는 붉게, 31×31은 푸르게, 안쪽 7×7은 초록으로 칠합니다.

상위 디렉터리의 [frame](../) 프로젝트와는 하는 일이 다릅니다. `frame`은 크누스의
별무늬로 **임의 크기의** 직사각 액자를 새로 짓는 생성기이고, 여기 `ktf`는 크누스의
**원본 세 투어 그 자체**를 되살려 검증하고 전시합니다.

## 필요한 것

| 도구 | 용도 |
| --- | --- |
| Go 1.26 이상 | `ktf.go` 실행 |
| GWEB (`gtangle`, `gweave`) | `.w`에서 Go 소스와 TeX 문서를 뽑아냄 |
| TeX Live (`mptopdf`, `luatex`) | MetaPost 그림과 문서 조판 |
| `kotexgweb`, `pic.tex` | 한글 GWEB 매크로와 그림 삽입 매크로 |
| Noto CJK 폰트 | 한글 조판 |

`go.mod`는 따로 두지 않고 상위 디렉터리의 모듈(`github.com/sjnam/knight-frame`)에
얹혀 있습니다.

## 빌드

```sh
make         # gtangle → go run → mptopdf → gweave → luatex
make clean   # 생성물 제거
```

문서 `ktf.pdf`(11쪽)와 겹친 액자 그림 `ktf-1.pdf`가 나옵니다.

프로그램만 돌려 검증 결과를 보려면 이렇게 합니다.

```sh
go run ktf.go
```

```text
 7×7  액자: 칸  48개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 0개
31×31 액자: 칸 336개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 3개
55×55 액자: 칸 624개, 하나의 닫힌 나이트 투어 ✓, 변마다 마디 7개
겹친 액자 ktf.mp를 썼다 (7·31·55, 진짜 닫힌 투어 셋).
```

## 투어를 적는 법

투어 하나는 **출발 칸과 이동 열**로 적습니다. 이동 열의 글자 하나는 나이트가 갈 수 있는
여덟 방향의 번호(`0`–`7`)이니, 한 액자를 도는 나이트의 발자국을 그대로 옮긴 것입니다.

```go
{cell{-6, -6}, "040573030550737575700346415212657520262750564737"}
```

세 액자를 한 중심에 겹치기 좋도록 **두 배 좌표**를 씁니다. 중심이 원점이고 칸은 짝수
자리에 놓이므로, 나이트 한 걸음은 방향 벡터를 두 배 한 것입니다. 세 이동 열의 길이는
48·336·624걸음으로, 폭 3칸 테두리의 칸 수 `12N-36`과 정확히 맞습니다.

## 검증하는 것

- **해밀턴** — 이동 열을 되짚어 칸으로 펼친 뒤, 모든 칸이 꼭 한 번씩만 나오는지 봅니다.
- **닫힘** — 마지막 걸음이 출발 칸으로 돌아오는지 봅니다.
- 걸음마다 나이트 거리인 것은 이동 열을 방향 번호로 지었으니 절로 참입니다. 위 둘이 다
  참이면 하나의 닫힌 나이트 투어입니다.
- **재귀** — 크누스의 "마디를 끼워 넣어 자란다"는 말을 확인합니다. 투어를 판 좌표의 이음
  집합으로 옮긴 뒤 위쪽 변을 훑어, 주기 6인 별무늬 한 마디(`knuthMod`, 이음 18개)가
  통째로 놓인 자리를 셉니다. 변마다 **0 → 3 → 7**개로, 큰 액자일수록 마디가 많습니다.
  가장 작은 7×7은 마디가 통째로 들어설 자리가 없어 네 모서리가 바로 맞물린 바탕꼴입니다.

## 파일

| 파일 | 설명 |
| --- | --- |
| [ktf.w](ktf.w) | GWEB 원본. Go 소스와 해설 문서를 겸함 |
| [Makefile](Makefile) | 빌드 |
| `myframe.pdf` | 문서의 페이지 배경으로 쓰는 세로 액자. `frame` 프로젝트가 지은 것 |
| `ktf.go`, `ktf.mp`, `ktf-1.pdf`, `ktf.tex`, `ktf.pdf` | 생성물 (`make clean` 대상) |
