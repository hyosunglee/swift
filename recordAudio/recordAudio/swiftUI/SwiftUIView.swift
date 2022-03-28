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
        
    
        ZStack{
            AngularGradient(gradient: Gradient(colors:[.red,.orange,.yellow,.green,.blue,.purple]), center: .center)
                            .edgesIgnoringSafeArea(.all)
            
            
            
            
            Text(text)
                .foregroundColor(Color.white)
                .padding(.top, -300)
            Image(image)
                .resizable()
                .frame(width: Frame.0, height: Frame.1)
                .border(Color.blue, width: 5)
            VStack {
                
                HStack(alignment: .center, spacing: 0) {
                    Group{
                        Text("Hi princess")
                            .foregroundColor(Color.white)
                            .padding(.top, -200)
                            .border(Color.red, width: 5)
                        Text(text)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 0)
                            .border(Color.green, width: 5)
                        
                    }
                }
            }
            .font(.largeTitle)
        }
    
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(text: "Simple Text", image: "String", Frame: (300, 300))
        
    }
}
