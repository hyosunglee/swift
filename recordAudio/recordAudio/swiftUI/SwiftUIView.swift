//
//  SwiftUIView.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/22.
//

import SwiftUI

struct SwiftUIView: View {
    
    var text: String
    var image : String
    var Frame :(CGFloat, CGFloat) = (Width: 300, height: 300)
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(Color.white)
                .padding(.top, -200)
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: Frame.0, height: Frame.1)
                
                Text("Hi princess")
                    .foregroundColor(Color.white)
                    .padding(.top, -200)
                Text(text)
                    .foregroundColor(Color.white)
                    .padding(.top, 100)
            }
        }
        .font(.largeTitle)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(text: "Simple Text", image: "String", Frame: (300, 300))
        
    }
}
