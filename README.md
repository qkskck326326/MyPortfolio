# MyPortfolio
>태그 기반 포트폴리오 검색 웹 플랫폼

## 배포 링크
[메인 페이지](https://myportfolio.co.kr/) | [개인 포트폴리오 페이지](https://myportfolio.co.kr/personal/1)

## 프로젝트 소개
MyPortfolio는 개인 포트폴리오 사이트로 활용 할 수 있는것을 목표로 하는 사이트 입니다.

태그를 이용한 효율적인 검색과 마크다운으로 글 등록, 실시간 이미지 업로드 등 
사용자 편의성에 중점을 두고 제작하였습니다.

또한 클라우드 인프라(OCI)를 사용하여 서비스를 클라우드 환경에 안정적으로 배포하고,
CI/CD를 구축하여 빌드 및 배포를 자동화 하였습니다.


## 기술 스택
|      구분      | 기술명/툴                                            |
| :----------: | :------------------------------------------------------|
|  **Backend** | Java, Spring Framework                                 |
| **Frontend** | JSP, JavaScript, JSTL, EL, jQuery                      |
|    **DB**    | MariaDB (MySQL compatible RDBMS)                       |
|    **ORM**   | MyBatis                                                |
| **Infra/배포** | Docker, Docker Compose                               |
|   **클라우드**   | Oracle Cloud Infrastructure (OCI)                  |
|   **CI/CD**  | GitHub Actions (자동 배포), Nginx (Reverse Proxy/HTTPS) |
| **Markdown** | Toast UI Editor                                        |
|    **CDN**   | imgbb(이미지 호스팅/CDN)                                |

## 주요 기능
### 포트폴리오 CRUD
- 등록 : Toast UI 에디터로 마크다운 및 커스텀 훅으로 이미지 업로드 지원
- 보기 : 등록된 포트폴리오를 마크다운 렌더링 방식으로 확인 할 수 있습니다.

### 태그 기반 포트폴리오 검색 및 필터
태그 시스템을 도입하여 포트폴리오 목록에서 원하는 태그로 포트폴리오를 빠르게 검색하거나,
여러 개의 태그를 조합해 세부적으로 필터링할 수 있습니다.

상세 페이지의 태그 클릭 시 해당 태그를 검색창에 추가합니다.

### 자동 배포 (CI/CD) 파이프라인 구축
GitHub Actions를 활용한 CI/CD 파이프라인을 구축하여,
코드가 저장소에 Push될 때마다
Docker 기반 자동 빌드 및 배포가 실행됩니다.

### 도메인 연결 + https 적용
Nginx 리버스 프록시 설정을 통해 외부 요청을 안전하게 백엔드로 라우팅하며, 
도메인 연결을 통해 서비스 접근성을 높였습니다.

또한 HTTPS(SSL) 암호화를 적용하여 데이터 전송의 기밀성과 무결성을 강화하고, 
SSL 인증서 자동 갱신 설정을 추가하여 SSL 인증서 유효기간 문제를 해소하였습니다.

