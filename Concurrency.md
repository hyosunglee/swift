Swift Concurrency 요약 및 실습 자료

Swift Concurrency는 Swift 5.5부터 도입된 비동기 프로그래밍 모델로, async/await, Task, actor 등을 활용하여 보다 안전하고 간결하게 비동기 코드를 작성할 수 있도록 도와줍니다.

1. Swift Concurrency 핵심 개념

✅ async / await
	•	async 키워드는 비동기 함수를 정의할 때 사용합니다.
	•	await 키워드는 비동기 함수의 실행 결과를 기다릴 때 사용합니다.
	•	기존 completion handler 방식보다 코드가 간결하고 가독성이 좋음.

📌 예제

func fetchData() async -> String {
    return "Hello, Swift Concurrency!"
}

Task {
    let result = await fetchData()
    print(result)
}

✅ Task
	•	새로운 비동기 작업을 생성하는 방법.
	•	Task { }를 사용하면 자동으로 비동기 환경에서 실행됨.
	•	Task.sleep(_:)을 사용하여 일정 시간 대기할 수도 있음.

📌 예제: Task 사용하기

Task {
    print("Start")
    try await Task.sleep(nanoseconds: 2_000_000_000) // 2초 대기
    print("End")
}

✅ TaskGroup
	•	여러 개의 비동기 작업을 병렬 실행하는 기능.
	•	withTaskGroup을 사용하여 여러 개의 비동기 작업을 동시에 실행할 수 있음.

📌 예제: TaskGroup 사용하기

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

✅ actor
	•	데이터 경쟁 문제(Data Race)를 방지하는 동시성 안전 타입.
	•	actor 내부의 변수는 동시에 여러 스레드에서 접근할 수 없음.

📌 예제: actor 사용하기

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

✅ MainActor
	•	메인 스레드에서 실행되도록 보장하는 기능.
	•	UI 업데이트가 필요한 작업을 @MainActor로 감싸서 안전하게 실행할 수 있음.

📌 예제: MainActor 사용하기

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

2. 실습 과제

📌 실습 1: async/await를 이용한 네트워크 요청
	1.	async/await를 사용하여 네트워크에서 JSON 데이터를 가져오는 코드를 작성하세요.
	2.	Task {}를 활용하여 데이터를 비동기적으로 가져오고 출력하세요.

import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

}
