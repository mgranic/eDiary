//
//  FullScaleImageScreen.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 18.09.2024..
//

import SwiftUI

struct FullScaleImageScreen: View {
    
    private var img: UIImage
    
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    
    @State private var currentOffset: CGSize = .zero
    @State private var finalOffset: CGSize = .zero
    
    init(img: UIImage) {
        self.img = img
    }
    
    var body: some View {
        Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(currentScale * finalScale)
            .offset(x: finalOffset.width + currentOffset.width,
                    y: finalOffset.height + currentOffset.height)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentScale = value
                        }
                        .onEnded { value in
                            finalScale *= value
                            currentScale = 1.0
                        },
                    DragGesture()
                        .onChanged { value in
                            currentOffset = value.translation
                        }
                        .onEnded { value in
                            finalOffset.width += currentOffset.width
                            finalOffset.height += currentOffset.height
                            currentOffset = .zero
                        }
                )
            )
            .animation(.easeInOut, value: currentScale)
            .animation(.easeInOut, value: currentOffset)
    }
}
