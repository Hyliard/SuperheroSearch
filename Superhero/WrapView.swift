//
//  WrapView.swift
//  Superhero
//
//  Created by Luis Martinez on 16/06/2025.
//

import SwiftUI

struct WrapView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 8, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .padding(spacing / 2)
                    .alignmentGuide(.leading) { d in
                        if currentX + d.width > geometry.size.width {
                            currentX = 0
                            currentY += d.height + spacing
                        }
                        let result = currentX
                        currentX += d.width + spacing
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = currentY
                        return result
                    }
            }
        }
    }
}

