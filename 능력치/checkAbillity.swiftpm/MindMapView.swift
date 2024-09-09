//
//  MindMapView.swift
//  checkAbillity
//
//  Created by 공사떼 on 2024/09/10.
//

import SwiftUI

struct MindMapView: View {
    let stat: String
    
    let mindMapData: [String: [String]] = [
        "힘": ["근력 운동", "단백질 섭취", "유산소 운동", "휴식과 회복"],
        "지능": ["독서", "퍼즐 게임", "새로운 기술 학습", "토론 참여"],
        "민첩": ["반응 속도 훈련", "균형 운동", "유연성 운동", "스포츠 활동"],
        "매력": ["의사소통 기술", "패션 센스", "자신감 개발", "친화력 향상"],
        "지혜": ["명상", "경험 공유", "철학 공부", "자기 성찰"],
        "체력": ["지구력 훈련", "균형 잡힌 식단", "충분한 수면", "스트레스 관리"]
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(stat) 향상을 위한 마인드맵")
                .font(.headline)
                .padding(.bottom)
            
            ForEach(mindMapData[stat] ?? [], id: \.self) { item in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                    Text(item)
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
    }
}
