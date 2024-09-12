//
//  MindMapView.swift
//  checkAbillity
//
//  Created by 공사떼 on 2024/09/10.
//

import SwiftUI

struct MindMapView: View {
    let stat: String  // stat을 받아서 사용할 수 있도록 추가
    
    @State private var mindMapData: [String: [String]] = [
        "힘": ["근력 운동", "단백질 섭취", "유산소 운동", "휴식과 회복"],
        "지능": ["독서", "퍼즐 게임", "새로운 기술 학습", "토론 참여"],
        "민첩": ["반응 속도 훈련", "균형 운동", "유연성 운동", "스포츠 활동"],
        "매력": ["의사소통 기술", "패션 센스", "자신감 개발", "친화력 향상"],
        "지혜": ["명상", "경험 공유", "철학 공부", "자기 성찰"],
        "체력": ["지구력 훈련", "균형 잡힌 식단", "충분한 수면", "스트레스 관리"]
    ]
    
    @State private var appearAnimation: Bool = false
    
    @State private var editingNode: String?
    @State private var newNodeText: String = ""
    @State private var selectedStat: String = ""
    
    var body: some View {
        
        
        VStack {
            // 마인드맵 루트 노드 (stat 선택)
//            Picker("카테고리", selection: $selectedStat) {
//                ForEach(Array(mindMapData.keys), id: \.self) { key in
//                    Text(key).tag(key)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
            
            Text("\(selectedStat) 향상을 위한 마인드맵")
                .font(.headline)
                .padding(.bottom)

            GeometryReader { geometry in
                let radius = min(geometry.size.width, geometry.size.height) / 2.5 // 화면 크기에 맞게 반지름 설정
                let centerX = geometry.size.width / 2
                let centerY = geometry.size.height / 2
                ZStack {
                    // 원점에서부터 각 아이템을 원형으로 배치
                    ForEach(Array(mindMapData[stat]!.enumerated()), id: \.offset) { index, item in
                        let angle = Angle(degrees: Double(index) / Double(mindMapData[stat]!.count) * 360.0)
                        let xOffset = cos(angle.radians) * radius
                        let yOffset = sin(angle.radians) * radius
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2) // 화면에 맞춰 원 크기 조정
                            .overlay(
                                Text(item)
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(8)
                            )
                            .position(x: centerX + xOffset, y: centerY + yOffset)
                            .scaleEffect(appearAnimation ? 1 : 0)  // 애니메이션 효과 적용
                            .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1), value: appearAnimation) // 각 원이 시간차를 두고 애니메이션
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .border(Color.gray)
                .onAppear {
                    appearAnimation = true  // 뷰가 나타날 때 애니메이션 실행
                }
                
            }
            
            
            Spacer()
            
            // 추가 및 편집/삭제 인터페이스
            if let editingNode = editingNode {
                Text("노드 편집 중: \(editingNode)")
                TextField("새 노드 텍스트", text: $newNodeText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("수정") {
                        if let index = mindMapData[selectedStat]?.firstIndex(of: editingNode) {
                            mindMapData[selectedStat]?[index] = newNodeText
                        }
                        self.editingNode = nil
                        self.newNodeText = ""
                    }
                    .padding(.trailing)
                    
                    Button("삭제") {
                        if let index = mindMapData[selectedStat]?.firstIndex(of: editingNode) {
                            mindMapData[selectedStat]?.remove(at: index)
                        }
                        self.editingNode = nil
                        self.newNodeText = ""
                    }
                    .foregroundColor(.red)
                }
                .padding()
            } else {
                TextField("새 노드 추가", text: $newNodeText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("추가") {
                    mindMapData[selectedStat]?.append(newNodeText)
                    newNodeText = ""
                }
            }
        }
        .padding()
    }
}

// 개별 노드를 표시하는 뷰
struct NodeView: View {
    let nodeText: String
    let index: Int
    var size: CGFloat = 100
    
    var body: some View {
        let angle = Angle(degrees: Double(index) * 360 / 6) // 단순한 노드 배치를 위해 6개의 노드를 원형으로 배치
        let x = cos(angle.radians) * 150
        let y = sin(angle.radians) * 150
        
        return VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: size, height: size)
                .overlay(
                    Text(nodeText)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                )
                .position(x: 200 + CGFloat(x), y: 200 + CGFloat(y)) // 기본 원 위치에서 offset
        }
    }
}




