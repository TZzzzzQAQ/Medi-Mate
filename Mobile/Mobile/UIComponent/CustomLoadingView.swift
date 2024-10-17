//
//  LoadingView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI

struct CustomLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .frame(width: 100, height: 100)
                .foregroundColor(Color.gray.opacity(0.3))
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 100)
                .foregroundColor(Color("bar"))
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

#Preview {
    CustomLoadingView()
}
