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
//  UITextViewRepresentable.swift
//  
//
//  Created by Kiarash Vosough on 11/27/20.
//

import SwiftUI

public struct UITextViewCallBacks {
    public typealias OnEditingChanged = () -> Void
    public typealias ShouldEditInRange = (Range<String.Index>, String) -> Bool
    public typealias OnCommit = () -> Void
    public typealias OnBeginEditing = () -> Void
    public typealias OnEndEditing = (_ finalText: String?) -> Void
}

internal struct UITextViewRepresentable {

    // MARK: - Bindings

    @Binding var textViewState: TextViewState
    @Binding var text: NSAttributedString?
    @Binding var calculatedHeight: CGFloat

    // MARK: - Modification Variables

    internal let placeHolderText: NSAttributedString?
    internal let keyboardType: UIKeyboardType
    internal let textColor: UIColor
    internal let placeholderTextColor: UIColor
    internal let autocapitalization: UITextAutocapitalizationType
    internal var multilineTextAlignment: TextAlignment
    internal let font: UIFont
    internal let returnKeyType: UIReturnKeyType?
    internal let autocorrection: UITextAutocorrectionType
    internal let truncationMode: NSLineBreakMode
    internal let isEditable: Bool
    internal let isSelectable: Bool
    internal let isScrollingEnabled: Bool
    internal let shouldExpandVertically: Bool
    internal let enablesReturnKeyAutomatically: Bool?
    internal var autoDetectionTypes: UIDataDetectorTypes = []
    internal var allowsRichText: Bool
    internal let inputAccessoryView: UIView?
    internal let maximumNumberOfLines: Int
    internal let isUserInteractionEnabled: Bool

    internal var onEditingChanged: UITextViewCallBacks.OnEditingChanged?
    internal var shouldEditInRange: UITextViewCallBacks.ShouldEditInRange?
    internal var onCommit: UITextViewCallBacks.OnCommit?
    internal var onBeginEditing: UITextViewCallBacks.OnBeginEditing?
    internal var onEndEditing: UITextViewCallBacks.OnEndEditing?

    // MARK: - LifeCycle

    internal init(
        text: Binding<NSAttributedString?>,
        calculatedHeight: Binding<CGFloat>,
        textViewState: Binding<TextViewState>,
        placeHolderText: NSAttributedString?,
        keyboardType: UIKeyboardType,
        textColor: UIColor,
        placeholderTextColor: UIColor,
        autocapitalization: UITextAutocapitalizationType,
        multilineTextAlignment: TextAlignment,
        font: UIFont,
        returnKeyType: UIReturnKeyType? = nil,
        autocorrection: UITextAutocorrectionType,
        truncationMode: NSLineBreakMode,
        isEditable: Bool,
        isSelectable: Bool,
        isScrollingEnabled: Bool,
        shouldExpandVertically: Bool,
        enablesReturnKeyAutomatically: Bool? = nil,
        autoDetectionTypes: UIDataDetectorTypes = [],
        allowsRichText: Bool,
        inputAccessoryView: UIView? = nil,
        maximumNumberOfLines: Int,
        isUserInteractionEnabled: Bool,
        onEditingChanged: UITextViewCallBacks.OnEditingChanged? = nil,
        shouldEditInRange: UITextViewCallBacks.ShouldEditInRange? = nil,
        onCommit: UITextViewCallBacks.OnCommit? = nil,
        onBeginEditing: UITextViewCallBacks.OnBeginEditing?,
        onEndEditing: UITextViewCallBacks.OnEndEditing?
    ) {
        self._text = text
        self._calculatedHeight = calculatedHeight
        self._textViewState = textViewState
        self.placeHolderText = placeHolderText
        self.keyboardType = keyboardType
        self.textColor = textColor
        self.placeholderTextColor = placeholderTextColor
        self.autocapitalization = autocapitalization
        self.multilineTextAlignment = multilineTextAlignment
        self.font = font
        self.returnKeyType = returnKeyType
        self.autocorrection = autocorrection
        self.truncationMode = truncationMode
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
        self.shouldExpandVertically = shouldExpandVertically
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.autoDetectionTypes = autoDetectionTypes
        self.allowsRichText = allowsRichText
        self.inputAccessoryView = inputAccessoryView
        self.maximumNumberOfLines = maximumNumberOfLines
        self.onEditingChanged = onEditingChanged
        self.shouldEditInRange = shouldEditInRange
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.onCommit = onCommit
        self.onBeginEditing = onBeginEditing
        self.onEndEditing = onEndEditing
    }
}

// MARK: - UIViewRepresentable

extension UITextViewRepresentable: UIViewRepresentable {

    internal func makeUIView(context: Context) -> UIKitTextView {
        context.coordinator.textView
    }

    internal func updateUIView(_ view: UIKitTextView, context: Context) {
        context.coordinator.update(representable: self)
    }

    internal func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            calculatedHeight: $calculatedHeight,
            textViewState: $textViewState,
            placeHolderText: placeHolderText,
            shouldExpandVertically: shouldExpandVertically,
            shouldEditInRange: shouldEditInRange,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit,
            onBeginEditing: onBeginEditing,
            onEndEditing: onEndEditing
        )
    }
}
