* Foundation : Module화의 기틀을 제공하는 클래스, 구조체들이 정의되어 있습니다.

   - Router : URLRequestConvertible을 채택한 프로토콜로, Routers 폴더에 있는 구체 타입들이 이 프로토콜을 채택합니다.

   - BaseService : 서버통신을 요청하기 위한 Service들이 공통적으로 상속하는 superClass입니다. 커스텀 AFManger와 judgeStatus 메서드가 존재합니다.

   - HeaderType : Router에서 반환할 헤더의 종류들이 정의되어 있습니다.

   - NetworkResult : 서버통신의 결과를 저장할 열거형 타입입니다.

* NetworkConstants : 서버통신에 필요한 BaseURL 또는 timeOut과 같은 상수들을 관리합니다.

* Routers : Router 프로토콜을 채택하여 header, path, parameter 등을 커스텀하여 request를 만들게 해줍니다.

* Service : 실제로 서버통신을 요청하기 위해 사용해야 하는 클래스입니다. 여러 endpoint들을 정의해두고 사용할 수 있습니다.

출처 - https://jazz-the-it.tistory.com/25
