Swift 공식 문서: Concurrency 요약 및 정리

Swift 공식 문서의 Concurrency 섹션은 Swift의 동시성(Concurrency) 기능을 설명하며, async/await, Task, TaskGroup, actor 등을 포함하여 안전하고 효율적인 비동기 프로그래밍을 할 수 있도록 도와줍니다.

1. 비동기 함수 (Asynchronous Functions)

✅ async와 await
	•	async 키워드는 비동기 함수를 정의할 때 사용합니다.
	•	await 키워드는 비동기 함수의 결과를 기다릴 때 사용합니다.

📌 예제:

func fetchData() async -> String {
    return "Hello, Swift Concurrency!"
}

Task {
    let result = await fetchData()
    print(result) // "Hello, Swift Concurrency!"
}

💡 핵심 포인트
	•	async 함수는 반드시 await으로 호출해야 함.
	•	await은 비동기 함수의 실행을 기다렸다가 결과를 반환함.

2. Task 및 Task Group

✅ Task의 개념
	•	Task를 사용하면 새로운 비동기 작업을 시작할 수 있음.
	•	Task.sleep()을 이용하면 일정 시간 대기 가능.

📌 예제: Task 사용하기

Task {
    print("Start")
    try await Task.sleep(nanoseconds: 2_000_000_000) // 2초 대기
    print("End")
}

✅ TaskGroup
	•	여러 개의 비동기 작업을 병렬 실행할 수 있음.
	•	withTaskGroup을 사용하여 여러 개의 작업을 동시에 실행 가능.

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

💡 핵심 포인트
	•	TaskGroup은 각 작업이 병렬적으로 실행될 수 있도록 함.
	•	for await을 사용하여 비동기적으로 실행된 결과를 순차적으로 가져옴.

3. Actor - 데이터 경쟁 방지

✅ actor의 개념
	•	actor는 **데이터 경쟁(Race Condition)**을 방지하는 Swift의 동시성 모델.
	•	actor 내부의 데이터는 동시에 여러 스레드에서 접근할 수 없음.

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

💡 핵심 포인트
	•	actor 내부의 데이터는 안전하게 보호됨.
	•	await을 사용하여 actor의 메서드를 호출해야 함.

4. MainActor - UI 업데이트를 안전하게 수행

✅ MainActor
	•	UI 관련 작업을 메인 스레드에서 안전하게 실행하도록 보장.
	•	SwiftUI에서 @MainActor를 사용하면 UI 업데이트를 비동기적으로 실행할 수 있음.

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

💡 핵심 포인트
	•	@MainActor는 UI 업데이트를 메인 스레드에서 실행하도록 보장함.
	•	task를 사용하여 View에서 비동기 작업을 수행할 수 있음.

5. 비동기 시퀀스 (AsyncSequence)

✅ AsyncSequence
	•	Swift에서 for await을 사용하여 비동기적으로 요소를 가져오는 시퀀스를 다룰 수 있음.

📌 예제: 비동기 스트리밍 데이터 처리

struct Counter: AsyncSequence {
    typealias Element = Int

    struct AsyncIterator: AsyncIteratorProtocol {
        var count = 0

        mutating func next() async -> Int? {
            if count >= 3 { return nil }
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
            count += 1
            return count
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator()
    }
}

Task {
    for await value in Counter() {
        print(value)
    }
}

💡 핵심 포인트
	•	AsyncSequence는 비동기 데이터 스트리밍을 처리할 때 유용함.
	•	for await을 사용하여 순차적으로 데이터를 가져올 수 있음.

6. 오류 처리 (Error Handling)
	•	Swift Concurrency에서도 do-catch 블록을 사용하여 오류를 처리할 수 있음.
	•	try await을 사용하여 비동기 작업에서 오류를 처리할 수 있음.

📌 예제: 오류 처리

enum NetworkError: Error {
    case invalidURL
    case requestFailed
}

func fetchData() async throws -> String {
    throw NetworkError.requestFailed
}

Task {
    do {
        let data = try await fetchData()
        print(data)
    } catch {
        print("Error: \(error)")
    }
}

💡 핵심 포인트
	•	async throws 함수는 비동기적으로 오류를 던질 수 있음.
	•	do-catch를 사용하여 오류를 처리할 수 있음.

7. 캔슬러블(Task Cancellation)
	•	Task는 실행 중 언제든지 취소할 수 있음.
	•	Task.isCancelled을 사용하여 현재 Task가 취소되었는지 확인할 수 있음.

📌 예제: Task 취소

Task {
    if Task.isCancelled {
        print("Task cancelled")
        return
    }

    try await Task.sleep(nanoseconds: 2_000_000_000)
    print("Task completed")
}

Task {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    print("Cancelling task...")
}

💡 핵심 포인트
	•	Task.isCancelled을 사용하여 취소 여부를 확인 가능.
	•	Task.sleep()을 사용하여 특정 시간 동안 대기 가능.

🎯 결론

Swift Concurrency는 기존의 completion handler 방식보다 훨씬 간결하고 안전한 비동기 프로그래밍을 가능하게 합니다.

✅ 핵심 개념 요약
	1.	async/await - 비동기 함수 호출을 간결하게.
	2.	Task - 새로운 비동기 작업을 실행.
	3.	TaskGroup - 병렬 실행을 관리.
	4.	actor - 데이터 경쟁 방지.
	5.	MainActor - UI 업데이트를 안전하게 실행.
	6.	AsyncSequence - 비동기 데이터 스트림 처리.
	7.	오류 처리 - try await과 do-catch 활용.
	8.	Task 취소 - Task.isCancelled로 취소 가능.

이제 공식 문서의 예제를 직접 실행해 보면서 Swift Concurrency를 더 깊이 익혀보세요!