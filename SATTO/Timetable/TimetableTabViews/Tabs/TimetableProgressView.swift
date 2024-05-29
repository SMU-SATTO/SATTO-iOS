//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/30/24.
//

import SwiftUI

struct TimetableProgressView: View {
    @State private var isLoading = false
    @State private var isWinking = false
    
    var body: some View {
        VStack {
            ZStack {
                progressCircle
                winkingSMU
            }
            .onAppear {
                withAnimation(
                    .linear(duration: 3.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isLoading = true
                }
            }
        }
    }
    
    private var winkingSMU: some View {
        VStack {
            Image(isWinking ? "LoadingSMU_wink" : "LoadingSMU")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .onAppear {
                    let firstTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                        self.isWinking.toggle()
                        let secondTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            self.isWinking.toggle()
                        }
                        RunLoop.current.add(secondTimer, forMode: .common)
                    }
                    RunLoop.current.add(firstTimer, forMode: .common)
                }
            Text("수뭉이 시간표 짜는중...")
                .font(.sb12)
        }
    }
    
    private var progressCircle: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 20
                )
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(isLoading ? .degrees(360) : .degrees(0))
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    VStack {
        TimetableProgressView()
    }
}
