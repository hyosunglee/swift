아래는 지금까지 나눈 RealityKit 기반 AR 개발 및 Swift Playgrounds 관련 대화 내용을 보기 쉽게 정리한 요약입니다:

---

# ✅ RealityKit + Swift Playgrounds AR 개발 요약

## 1. 목적

* RealityKit을 이용한 간단한 AR 장면 테스트
* Swift Playgrounds(iPad 또는 Mac) 환경에서:

  * 기본 가상 객체(박스 등) 렌더링
  * 제스처를 통한 이동, 회전, 스케일 조절

---

## 2. 실행 환경에 따른 구분

| 환경                              | 사용 가능 모듈                    | 실행 방식                                     | 비고             |
| ------------------------------- | --------------------------- | ----------------------------------------- | -------------- |
| Swift Playgrounds (.playground) | ✅ `PlaygroundSupport`       | `PlaygroundPage.current.setLiveView()` 사용 | iPad 또는 Mac용 앱 |
| 일반 iOS 앱 프로젝트                   | ❌ `PlaygroundSupport` 사용 불가 | `@main` 및 SwiftUI App 구조 사용               | Xcode 프로젝트     |

---

## 3. 오류 및 해결

### ❌ `No such module 'PlaygroundSupport'`

* 원인: iOS 앱 프로젝트에서 `PlaygroundSupport` 사용
* 해결: 앱에서는 `@main`, `WindowGroup`, `ContentView()` 구조로 구현해야 함

### ❌ `Expressions are not allowed at the top level`

* 원인: 일반 `.swift` 파일에서 최상위에서 실행 표현식 사용
* 해결:

  * SwiftUI 앱 구조 안에서 `var body: some View` 등 내부에 넣어야 함
  * Playground에서는 허용됨

---

## 4. RealityKit AR 예제 (SwiftUI 앱 전용)

```swift
import SwiftUI
import RealityKit

struct RealityKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let box = ModelEntity(mesh: .generateBox(size: 0.3),
                              materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        box.generateCollisionShapes(recursive: true)
        arView.installGestures([.all], for: box)

        let anchor = AnchorEntity(world: [0, 0, -0.5])
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        RealityKitView().edgesIgnoringSafeArea(.all)
    }
}

@main
struct MyARApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## 5. Swift Playgrounds (.playground) 전용 코드

```swift
import SwiftUI
import RealityKit
import PlaygroundSupport

struct RealityKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let box = ModelEntity(mesh: .generateBox(size: 0.3),
                              materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        box.generateCollisionShapes(recursive: true)
        arView.installGestures([.all], for: box)

        let anchor = AnchorEntity(world: [0, 0, -0.5])
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        RealityKitView()
    }
}

// Playground 실행
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(ContentView())
```

---

## 6. 참고 사항

* iPad용 Swift Playgrounds에서 실행할 경우 **카메라 권한**을 설정해야 AR 동작 가능
* Mac에서는 카메라가 없어 RealityKit AR 기능이 동작하지 않을 수 있음
* RealityKit의 `.generateBox`, `.generateSphere` 등 기본 도형으로 시작하고, 제스처를 통해 인터랙션 구현 가능

---

필요하시면 추가적으로 `ARFaceTracking`, `Physics`, `AnchorEntity` 종류별 차이 등도 확장해드릴 수 있습니다.
