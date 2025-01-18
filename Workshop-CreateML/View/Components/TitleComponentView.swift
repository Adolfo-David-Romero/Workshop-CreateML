//
//  TitleComponentView.swift
//  Workshop-CreateML
//
//  Created by David Romero on 2025-01-18.
//

import SwiftUI

struct TitleComponentView: View {
    var body: some View {
        Text("Super Wicked Genre Classifier")
            .font(.system(size: 40.0, weight: .bold, design: .rounded))
            .padding(.top)
    }
}

#Preview {
    TitleComponentView()
}

