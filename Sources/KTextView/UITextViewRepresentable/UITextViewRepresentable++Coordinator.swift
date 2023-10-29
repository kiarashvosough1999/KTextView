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
//  UITextViewRepresentable++Coordinator.swift
//  
//
//  Created by Kiarash Vosough on 11/27/20.
//

import SwiftUI

// MARK: - Coordinator

extension UITextViewRepresentable {

    internal final class Coordinator: NSObject {

        // MARK: - View

        internal let textView: UIKitTextView

        // MARK: - Variables

        private var originalText: NSAttributedString? = NSAttributedString()

        // MARK: - Bindings

        private var text: Binding<NSAttributedString?>
        private var textViewState: Binding<TextViewState>
        private var calculatedHeight: Binding<CGFloat>

        // MARK: - CallBacks

        private let onCommit: UITextViewCallBacks.OnCommit?
        private let onEditingChanged: UITextViewCallBacks.OnEditingChanged?
        private let shouldEditInRange: UITextViewCallBacks.ShouldEditInRange?
        private let onBeginEditing: UITextViewCallBacks.OnBeginEditing?
        private let onEndEditing: UITextViewCallBacks.OnEndEditing?

        // MARK: - Inputs

        private let shouldExpandVertically: Bool
        private var placeHolderText: NSAttributedString?

        // MARK: - LifeCycle

        internal init(
            text: Binding<NSAttributedString?>,
            calculatedHeight: Binding<CGFloat>,
            textViewState: Binding<TextViewState>,
            placeHolderText: NSAttributedString?,
            shouldExpandVertically: Bool,
            shouldEditInRange: UITextViewCallBacks.ShouldEditInRange?,
            onEditingChanged: UITextViewCallBacks.OnEditingChanged?,
            onCommit: UITextViewCallBacks.OnCommit?,
            onBeginEditing: UITextViewCallBacks.OnBeginEditing?,
            onEndEditing: UITextViewCallBacks.OnEndEditing?
        ) {
            self.textView = UIKitTextView()
            self.textView.backgroundColor = .clear
            self.textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            self.text = text
            self.calculatedHeight = calculatedHeight
            self.textViewState = textViewState
            self.placeHolderText = placeHolderText
            self.shouldExpandVertically = shouldExpandVertically
            self.shouldEditInRange = shouldEditInRange
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
            self.onBeginEditing = onBeginEditing
            self.onEndEditing = onEndEditing
            super.init()
            textView.delegate = self
            textView.pasteDelegate = self
        }
    }
}

// MARK: - UITextPasteDelegate

extension UITextViewRepresentable.Coordinator: UITextPasteDelegate {

    internal func textPasteConfigurationSupporting(
        _ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting,
        performPasteOf attributedString: NSAttributedString,
        to textRange: UITextRange
    ) -> UITextRange {
        textView.replace(textRange, withText: attributedString.string)
        return textRange
    }
}

// MARK: - UITextViewDelegate

extension UITextViewRepresentable.Coordinator: UITextViewDelegate {

    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewState.wrappedValue == .placeholder {
            text.wrappedValue = nil
            textViewState.wrappedValue = .text

            let range = NSRange(location: textView.text.count - 1, length: 0)
            textView.scrollRangeToVisible(range)
        }
        originalText = text.wrappedValue
        onBeginEditing?()
    }

    internal func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            text.wrappedValue = nil
            textView.resignFirstResponder()
        } else {
            text.wrappedValue = NSAttributedString(attributedString: textView.attributedText)
        }
        recalculateHeight()
        onEditingChanged?()
    }

    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var containsNewLineCharachter: Bool { text.rangeOfCharacter(from: CharacterSet.newlines) != nil }
        if shouldExpandVertically == false && containsNewLineCharachter == true { return false }
        if onCommit != nil, containsNewLineCharachter == true {
            onCommit?()
            originalText = NSAttributedString(attributedString: textView.attributedText)
            return false
        }

        guard
            let text = textView.text,
            let range = Range(range, in: text),
            let shouldEditInRange = shouldEditInRange
        else { return true }

        return shouldEditInRange(range, text)
    }

    internal func textViewDidEndEditing(_ textView: UITextView) {
        // this check is to ensure we always commit text when we're not using a closure
        if onCommit != nil {
            text.wrappedValue = originalText
        }
        if textView.text.isEmpty {
            textViewState.wrappedValue = .placeholder
            textView.attributedText = placeHolderText
        }
        onEndEditing?(text.wrappedValue?.string)
    }
}

// MARK: - Update View Methods

extension UITextViewRepresentable.Coordinator {

    internal func update(representable: UITextViewRepresentable) {
        textView.attributedText = representable.textViewState == .text ? representable.text : representable.placeHolderText
        textView.textColor = representable.textViewState == .text ? representable.textColor : representable.placeholderTextColor
        textView.font = representable.font
        textView.adjustsFontForContentSizeCategory = true
        textView.autocapitalizationType = representable.autocapitalization
        textView.autocorrectionType = representable.autocorrection
        textView.isEditable = representable.isEditable
        textView.isSelectable = representable.isSelectable
        textView.isScrollEnabled = representable.isScrollingEnabled
        textView.dataDetectorTypes = representable.autoDetectionTypes
        textView.allowsEditingTextAttributes = representable.allowsRichText
        textView.textContainer.maximumNumberOfLines = representable.maximumNumberOfLines
        textView.textContainer.lineBreakMode = representable.truncationMode
        textView.keyboardType = representable.keyboardType
        textView.inputAccessoryView = representable.inputAccessoryView
        textView.isUserInteractionEnabled = representable.isUserInteractionEnabled

        switch representable.multilineTextAlignment {
        case .leading:
            textView.textAlignment = textView.traitCollection.layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            textView.textAlignment = textView.traitCollection.layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            textView.textAlignment = .center
        }

        if let value = representable.enablesReturnKeyAutomatically {
            textView.enablesReturnKeyAutomatically = value
        } else {
            textView.enablesReturnKeyAutomatically = onCommit == nil ? false : true
        }

        if let returnKeyType = representable.returnKeyType {
            textView.returnKeyType = returnKeyType
        } else {
            textView.returnKeyType = onCommit == nil ? .default : .done
        }

        if !representable.isScrollingEnabled {
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = .zero
        }

        recalculateHeight()
        textView.setNeedsDisplay()
    }

    private func recalculateHeight() {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        guard calculatedHeight.wrappedValue != newSize.height else { return }

        DispatchQueue.main.async { // call in next render cycle.
            self.calculatedHeight.wrappedValue = newSize.height
        }
    }
}
