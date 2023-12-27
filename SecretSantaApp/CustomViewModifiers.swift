//
//  CustomViewModifiers.swift
//  FP_Elfster
//
//  Created by Arianna Foo on 2023-12-03.
//

import Foundation
import SwiftUI

struct AppTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(10)
            .frame(maxHeight: 30)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding(10)
    }
}

struct AppButtonModifier: ViewModifier {
    var font: Font = .title
    // Creating custom colour
    var backgroundColor: Color = Color(red: 56/255, green: 171/255, blue: 28/255, opacity: 1.0)
    func body(content: Content) -> some View {
        return content
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 10)
    }
}

struct AppButtonTextModifier: ViewModifier{
    var font: Font = .title
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.white)
            .font(.body)
            .fontWeight(.bold)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
    }
}

struct HStackImageModifier: ViewModifier{
    var font: Font = .title
    func body(content: Content) -> some View {
        return content
            //.padding(.trailing)
            .font(.headline)
            .foregroundColor(Color.black)
            .fontWeight(.medium)
    }
}

struct HStackTextModifier: ViewModifier{
    var font: Font = .title
    func body(content: Content) -> some View {
        return content
            //.padding(.trailing)
            .font(.headline)
            .foregroundColor(Color.black)
            .fontWeight(.medium)
    }
}
