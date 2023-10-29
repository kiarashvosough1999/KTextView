//  MIT License
//
//  Copyright (c) 2020 Kiarash Vosough
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  KTextView.swift
//
//
//  Created by Kiarash Vosough on 11/27/20.
//

import SwiftUI

/// A SwiftUI TextView implementation that supports both scrolling and auto-sizing layouts
public struct KTextView: View {

    // MARK: Bindings

    @Binding private var text: NSAttributedString?

    // MARK: - States

    @State private var calculatedHeight: CGFloat = 50
    @State internal var textViewState: UITextViewRepresentable.TextViewState

    // MARK: - Changes CallBacks

    internal var onEditingChanged: UITextViewCallBacks.OnEditingChanged?
    internal var shouldEditInRange: UITextViewCallBacks.ShouldEditInRange?
    internal var onCommit: UITextViewCallBacks.OnCommit?
    internal var onBeginEditing: UITextViewCallBacks.OnBeginEditing?
    internal var onEndEditing: UITextViewCallBacks.OnEndEditing?

    // MARK: - Modifiable Properties

    // Text and Font
    internal var placeHolderText: NSAttributedString?
    internal var font: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)

    // Colors
    internal var textColor: UIColor = .black
    internal var placeholderTextColor: UIColor = .lightGray

    // Textview Config
    internal var keyboardType: UIKeyboardType = .default
    internal var multilineTextAlignment: TextAlignment = .leading
    internal var autocorrection: UITextAutocorrectionType = .default
    internal var truncationMode: NSLineBreakMode = .byTruncatingTail
    internal var autocapitalization: UITextAutocapitalizationType = .sentences
    internal var returnKeyType: UIReturnKeyType?
    internal var maximumNumberOfLines: Int = 0
    internal var isEditable: Bool = true
    internal var isSelectable: Bool = true
    internal var allowRichText: Bool
    internal var inputAccessoryView: UIView?
    internal var autoDetectionTypes: UIDataDetectorTypes = []
    internal var isScrollingEnabled: Bool = false
    internal var enablesReturnKeyAutomatically: Bool?

    // Gesture Config
    internal var isUserInteractionEnabled: Bool = true

    // Layout Config
    internal var shouldExpandVertically: Bool = true

    // MARK: - LifeCycle

    /// Makes a new KTextView with the specified configuration
    /// - Parameters:
    ///   - text: A binding to the text
    public init(
        _ text: Binding<String?>,
        placeHolderText: String? = nil
    ) {
        self._text = Binding(
            get: {
                guard let unwrappedText = text.wrappedValue else { return nil }
                return NSAttributedString(string: unwrappedText)
            },
            set: { text.wrappedValue = $0?.string }
        )
        self.allowRichText = false
        self.placeHolderText = placeHolderText != nil ? NSAttributedString(string: placeHolderText!) : nil
        self.textViewState = placeHolderText != nil && text.wrappedValue == nil ? .placeholder : .text
    }

    /// Makes a new KTextView that supports `NSAttributedString`
    /// - Parameters:
    ///   - text: A binding to the attributed text
    public init(
        _ text: Binding<NSAttributedString?>,
        placeHolderText: NSAttributedString? = nil
    ) {
        self._text = text
        self.placeHolderText = placeHolderText
        self.allowRichText = true
        self.textViewState = placeHolderText != nil && text.wrappedValue == nil ? .placeholder : .text
    }

    // MARK: - Body

    public var body: some View {
        UITextViewRepresentable(
            text: $text,
            calculatedHeight: $calculatedHeight,
            textViewState: $textViewState,
            placeHolderText: placeHolderText,
            keyboardType: keyboardType,
            textColor: textColor,
            placeholderTextColor: placeholderTextColor,
            autocapitalization: autocapitalization,
            multilineTextAlignment: multilineTextAlignment,
            font: font,
            returnKeyType: returnKeyType,
            autocorrection: autocorrection,
            truncationMode: truncationMode,
            isEditable: isEditable,
            isSelectable: isSelectable,
            isScrollingEnabled: isScrollingEnabled,
            shouldExpandVertically: shouldExpandVertically,
            enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
            autoDetectionTypes: autoDetectionTypes,
            allowsRichText: allowRichText,
            inputAccessoryView: inputAccessoryView,
            maximumNumberOfLines: maximumNumberOfLines,
            isUserInteractionEnabled: isUserInteractionEnabled,
            onEditingChanged: onEditingChanged,
            shouldEditInRange: shouldEditInRange,
            onCommit: onCommit,
            onBeginEditing: onBeginEditing,
            onEndEditing: onEndEditing
        )
        .frame(
            minHeight: isScrollingEnabled ? 0 : calculatedHeight,
            maxHeight: isScrollingEnabled ? .greatestFiniteMagnitude : calculatedHeight
        )
        .animation(.easeInOut(duration: 0.2), value: calculatedHeight)
    }
}

// MARK: - Preview

#Preview {
    KTextView(.constant("Some"))
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundColor(Color(.placeholderText))
        )
        .padding()
}
