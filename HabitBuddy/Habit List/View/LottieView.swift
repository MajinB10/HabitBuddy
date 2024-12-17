////
////  LottieView.swift
////  HabitBuddy
////
////  Created by Bhavesh Anand on 17/12/24.
////
//
//import SwiftUI
//import Lottie
//
//struct LottieView: UIViewRepresentable {
//    let animationName: String
//    var loopMode: LottieLoopMode = .playOnce
//    
//    let animationView = LottieAnimationView()
//
//    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
//        let view = UIView(frame: .zero)
//        animationView.animation = LottieAnimation.named(animationName)
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = loopMode
//        animationView.play()
//        
//        view.addSubview(animationView)
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
//        ])
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
//}
