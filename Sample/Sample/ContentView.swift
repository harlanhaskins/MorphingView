//
//  ContentView.swift
//  MorphingView
//
//  Created by Harlan Haskins on 1/8/25.
//

import MorphingView
import SwiftUI
import UIKit

struct UIViewAdaptor: UIViewRepresentable {
    var view: UIView

    func makeUIView(context: Context) -> some UIView {
        view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

func makeTestView() -> UIView {
    let width = CGFloat.random(in: 100..<200)
    let height = CGFloat.random(in: 100..<200)
    let v = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    v.backgroundColor = UIColor(hue: .random(in: 0..<1), saturation: 0.7, brightness: 0.9, alpha: 1)
    return v
}

func makeTestImage(two: Bool = false) -> UIImageView {
    let image = UIImage(named: "TestImage\(two ? "2" : "")")!
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.bounds.size = image.size.scaledToFit(CGSize(width: 300, height: 300))
    return imageView
}

struct ContentView: View {
    @State var view = MorphingView(views: [ makeTestImage(), makeTestImage(two: true), makeTestView(), makeTestView(), makeTestView()])
    @State var morphID: Int = 0
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                UIViewAdaptor(view: view)
                    .frame(width: 300, height: 300)
                MorphView(id: morphID) {
                    Image("TestImage")
                        .resizable()
                        .scaledToFit()
                        .tag(0)
                    Image("TestImage2")
                        .resizable()
                        .scaledToFit()
                        .tag(1)
                    Text("This is a long message, I am testing morphing to text")
                        .frame(width: 100)
                        .tag(2)
                }
                .frame(width: 300, height: 300)
            }

            HStack {
                Button("Previous", systemImage: "chevron.backward") {
                    changeImage(offset: -1)
                }
                Button("Next", systemImage: "chevron.forward") {
                    changeImage(offset: 1)
                }
            }
            .buttonBorderShape(.circle)
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
        }
        .padding()
    }

    func changeImage(offset: Int) {
        let newIndex = view.index + offset
        view.morph(to: newIndex, timingParameters: UISpringTimingParameters(duration: 0.4, bounce: 0.1))
        withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
            morphID += offset
            if morphID > 2 {
                morphID = 0
            }
            if morphID < 0 {
                morphID = 2
            }
        }
    }
}

#Preview {
    ContentView()
}
