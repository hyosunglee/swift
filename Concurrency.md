Swift Concurrency 요약 및 실습 자료

Swift Concurrency는 Swift 5.5부터 도입된 비동기 프로그래밍 모델로, async/await, Task, actor 등을 활용하여 보다 안전하고 간결하게 비동기 코드를 작성할 수 있도록 도와줍니다.

1. Swift Concurrency 핵심 개념

✅ async / await
	•	async 키워드는 비동기 함수를 정의할 때 사용합니다.
	•	await 키워드는 비동기 함수의 실행 결과를 기다릴 때 사용합니다.
	•	기존 completion handler 방식보다 코드가 간결하고 가독성이 좋음.

📌 예제
```swift
func fetchData() async -> String {
    return "Hello, Swift Concurrency!"
}

Task {
    let result = await fetchData()
    print(result)
}
```
✅ Task
	•	새로운 비동기 작업을 생성하는 방법.
	•	Task { }를 사용하면 자동으로 비동기 환경에서 실행됨.
	•	Task.sleep(_:)을 사용하여 일정 시간 대기할 수도 있음.

📌 예제: Task 사용하기
```swift
Task {
    print("Start")
    try await Task.sleep(nanoseconds: 2_000_000_000) // 2초 대기
    print("End")
}
```
✅ TaskGroup
	•	여러 개의 비동기 작업을 병렬 실행하는 기능.
	•	withTaskGroup을 사용하여 여러 개의 비동기 작업을 동시에 실행할 수 있음.

📌 예제: TaskGroup 사용하기
```swift
import Foundation

func fetchMultipleData() async {
    await withTaskGroup(of: String.self) { group in
        group.addTask { "Task 1 완료" }
        group.addTask { "Task 2 완료" }

        for await result in group {
            print(result)
        }
    }
}

Task {
    await fetchMultipleData()
}
```
✅ actor
	•	데이터 경쟁 문제(Data Race)를 방지하는 동시성 안전 타입.
	•	actor 내부의 변수는 동시에 여러 스레드에서 접근할 수 없음.

📌 예제: actor 사용하기
```swift
actor Counter {
    private var count = 0

    func increment() {
        count += 1
    }

    func getCount() -> Int {
        return count
    }
}

let counter = Counter()

Task {
    await counter.increment()
    print(await counter.getCount()) // 1
}
```
✅ MainActor
	•	메인 스레드에서 실행되도록 보장하는 기능.
	•	UI 업데이트가 필요한 작업을 @MainActor로 감싸서 안전하게 실행할 수 있음.

📌 예제: MainActor 사용하기
```swift
import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    @Published var message: String = "Loading..."

    func loadData() async {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        message = "Data Loaded"
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        Text(viewModel.message)
            .task {
                await viewModel.loadData()
            }
    }
}
```
2. 실습 과제

📌 실습 1: async/await를 이용한 네트워크 요청
	1.	async/await를 사용하여 네트워크에서 JSON 데이터를 가져오는 코드를 작성하세요.
	2.	Task {}를 활용하여 데이터를 비동기적으로 가져오고 출력하세요.
```swift
import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

func fetchUser() async throws -> User {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users/1")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

Task {
    do {
        let user = try await fetchUser()
        print("User: \(user.name)")
    } catch {
        print("Error: \(error)")
    }
}
```
📌 실습 2: TaskGroup을 사용하여 병렬 요청 처리
	1.	3개의 다른 API에서 데이터를 동시에 가져오고, 모든 결과를 출력하세요.
	2.	withTaskGroup(of: String.self)을 사용하여 동시에 여러 작업을 실행하세요.

```swift
import Foundation

func fetchData(from url: String) async -> String {
    guard let url = URL(string: url) else { return "Invalid URL" }
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(data: data, encoding: .utf8) ?? "No Data"
    } catch {
        return "Error fetching data"
    }
}

Task {
    await withTaskGroup(of: String.self) { group in
        let urls = [
            "https://jsonplaceholder.typicode.com/todos/1",
            "https://jsonplaceholder.typicode.com/todos/2",
            "https://jsonplaceholder.typicode.com/todos/3"
        ]

        for url in urls {
            group.addTask {
                await fetchData(from: url)
            }
        }

        for await result in group {
            print(result)
        }
    }
}
```
📌 실습 3: actor를 이용한 데이터 동기화
	1.	actor를 사용하여 스레드 안전한 카운터를 구현하세요.
	2.	여러 개의 Task가 동시에 increment()를 실행하도록 해보세요.
```swift
actor SafeCounter {
    private var count = 0

    func increment() {
        count += 1
    }

    func getCount() -> Int {
        return count
    }
}

let counter = SafeCounter()

Task {
    await counter.increment()
    await counter.increment()
    await counter.increment()
    print("Final Count: \(await counter.getCount())") // 3
}
```
3. 결론

Swift Concurrency는 비동기 코드의 안정성과 가독성을 높이는 강력한 기능입니다.
특히 async/await, Task, actor, TaskGroup을 활용하면 보다 안전하고 직관적인 비동기 코드를 작성할 수 있습니다.

✅ 주요 정리
	•	async/await → 비동기 코드 간결화
	•	Task → 비동기 작업 실행
	•	TaskGroup → 여러 개의 비동기 작업을 병렬 실행
	•	actor → 동시성 문제 해결
	•	MainActor → UI 업데이트를 안전하게 실행

Swift Concurrency를 직접 실습하면서 기존의 completion handler 기반 코드와 비교해보는 것이 가장 효과적인 학습 방법입니다.
