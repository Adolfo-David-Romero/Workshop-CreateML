//
//  AnimatedBackgroundView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct AnimatedBackgroundView: View {
    private enum AnimationProperties {
        static let animationSpeed: Double = 4
        static let timerDuration: TimeInterval = 3
        static let blurRadius: CGFloat = 130
    }

    @ObservedObject private var animator: CircleAnimator
    @State private var timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()

    init(colors: [Color]) {
        self.animator = CircleAnimator(colors: colors)
    }

    var body: some View {
        ZStack {
            ForEach(animator.circles) { circle in
                MovingCircle(originOffset: circle.position)
                    .foregroundStyle(circle.color)
            }
        }
        .blur(radius: AnimationProperties.blurRadius)
        .onAppear {
            animateCircles()
            timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common)
                .autoconnect()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onReceive(timer) { _ in
            animateCircles()
        }
    }

    private func animateCircles() {
        withAnimation(.easeInOut(duration: AnimationProperties.animationSpeed)) {
            animator.animate()
        }
    }
}
class CircleAnimator: ObservableObject {
    class Circle: Identifiable {
        internal init(position: CGPoint, color: Color) {
            self.position = position
            self.color = color
        }
        var position: CGPoint
        let id = UUID().uuidString
        let color: Color
    }

    @Published private(set) var circles: [Circle] = []

    init(colors: [Color]) {
        circles = colors.map { color in
            Circle(position: CircleAnimator.generateRandomPosition(), color: color)
        }
    }

    func animate() {
        objectWillChange.send()
        for circle in circles {
            circle.position = CircleAnimator.generateRandomPosition()
        }
    }

    static func generateRandomPosition() -> CGPoint {
        CGPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
    }
}
struct MovingCircle: Shape {
    var originOffset: CGPoint

    var animatableData: CGPoint.AnimatableData {
        get {
            originOffset.animatableData
        }
        set {
            originOffset.animatableData = newValue
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let adjustedX = rect.width * originOffset.x
        let adjustedY = rect.height * originOffset.y
        let smallestDimension = min(rect.width, rect.height)

        path.addArc(center: CGPoint(x: adjustedX, y: adjustedY), radius: smallestDimension, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
        return path
    }
}
enum GradientColors {
    static var all: [Color] {
        [
            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
            Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
            Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)),
            Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        ]
    }

    static var backgroundColor: Color {
        Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
    }
}


#Preview {
    AnimatedBackgroundView(colors: [.teal])
}
