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
//  KTextView++Modifiers.swift
//
//  Created by Kiarash Vosough on 11/27/20.
//

import SwiftUI

extension KTextView {

    public func isUserInteactionEnabled(_ enabled: Bool) -> KTextView {
        var view = self
        view.isUserInteractionEnabled = enabled
        return view
    }

    public func onBeginEditing(_ callback: @escaping UITextViewCallBacks.OnBeginEditing) -> KTextView {
        var view = self
        view.onBeginEditing = callback
        return view
    }

    public func onEndEditing(_ callback: @escaping UITextViewCallBacks.OnEndEditing) -> KTextView {
        var view = self
        view.onEndEditing = callback
        return view
    }

    public func onEditingChanged(_ callback: @escaping UITextViewCallBacks.OnEditingChanged) -> KTextView {
        var view = self
        view.onEditingChanged = callback
        return view
    }

    public func shouldEditInRange(_ callback: @escaping UITextViewCallBacks.ShouldEditInRange) -> KTextView {
        var view = self
        view.shouldEditInRange = callback
        return view
    }

    /// Setting this closure will prevent from setting `text` binding.
    /// Full text will be sent when editing is finished and during editing.
    ///
    public func onCommit(_ callback: @escaping UITextViewCallBacks.OnCommit) -> KTextView {
        var view = self
        view.onCommit = callback
        return view
    }

    /// Specifies the type of keyboard that shows up on editing.
    ///
    /// - Parameter type: of type `UIKeyboardType`
    ///
    public func keyboardType(_ type: UIKeyboardType) -> KTextView {
        var view = self
        view.keyboardType = type
        return view
    }

    /// Setting an `AccessoryView` for KTextView
    ///
    /// - Parameter accessoryView: of type `UIView`
    ///
    public func inputAccessoryView(_ accessoryView: UIView?) -> KTextView {
        var view = self
        view.inputAccessoryView = accessoryView
        return view
    }

    /// This method is associated with `shouldExpandVertically`,
    ///
    /// setting `0` means infinite number of lines.
    ///
    /// default to `0`.
    ///
    /// - Parameter count: count of lines
    ///
    public func maximumNumberOfLines(_ count: Int) -> KTextView {
        var view = self
        view.maximumNumberOfLines = count
        return view
    }

    /// This method is associated with `maximumNumberOfLines`,
    /// it actually controlls the `\n` inputs whether by `Enter Button` or `Reaching End Of Textfield Width`.
    ///
    ///  if value is set to true and `maximumNumberOfLines == 0`,
    ///  The size of the `KTextView` will increase and cursor will move to new line
    ///  if user enter newline or fill the width with words.
    ///
    ///  if value is set to true and `maximumNumberOfLines == 1`,
    ///  `KTextView` won't expand and user can enter input in one line,
    ///  the `TruncationMode` on this state is set to `.byTruncatingTail`.
    ///
    ///  if value is set to false and `maximumNumberOfLines == 0`,
    ///  `KTextView` will expand if only user reach the end of the width,
    ///
    /// Consideration:
    ///
    /// Settting a specific height by using `.frame(height:)` modifier will prevents the `KTextView`,
    /// even if `shouldExpandVertically == true` or `maximumNumberOfLines = 0`.
    ///
    /// default to `true`.
    ///
    public func shouldExpandVertically(_ enabled: Bool) -> KTextView {
        var view = self
        view.shouldExpandVertically = enabled
        return view
    }

    /// Specifies whether or not this view allows rich text
    ///
    /// - Parameter enabled: If `true`, rich text editing controls will be enabled for the user.
    ///
    public func allowsRichText(_ enabled: Bool) -> KTextView {
        var view = self
        view.allowRichText = enabled
        return view
    }

    /// Enables auto detection for the specified types.
    ///
    /// - Parameter types: The types to detect.
    ///
    func autoDetectDataTypes(_ types: UIDataDetectorTypes) -> KTextView {
        var view = self
        view.autoDetectionTypes = types
        return view
    }

    /// Specify the color for the text.
    ///
    /// - Parameter color: The foreground color.
    ///
    func textColor(_ color: UIColor) -> KTextView {
        var view = self
        view.textColor = color
        return view
    }

    /// Specifies the capitalization style to apply to the text.
    ///
    /// - Parameter style: The capitalization style.
    ///
    func autocapitalization(_ style: UITextAutocapitalizationType) -> KTextView {
        var view = self
        view.autocapitalization = style
        return view
    }

    /// Specifies the alignment of multi-line text.
    ///
    /// - Parameter alignment: The text alignment.
    ///
    func multilineTextAlignment(_ alignment: TextAlignment) -> KTextView {
        var view = self
        view.multilineTextAlignment = alignment
        return view
    }

    /// Specifies the font to apply to the text.
    ///
    /// - Parameter font: The font to apply.
    ///
    func font(_ font: UIFont) -> KTextView {
        var view = self
        view.font = font
        return view
    }

    /// Disables auto-correct
    ///
    /// - Parameter disable: If true, autocorrection will be disabled.
    ///
    func disableAutocorrection(_ disable: Bool?) -> KTextView {
        var view = self
        if let disable = disable {
            view.autocorrection = disable ? .no : .yes
        } else {
            view.autocorrection = .default
        }
        return view
    }

    /// Specifies whether the text can be edited.
    ///
    /// - Parameter isEditable: If true, the text can be edited via the user's keyboard.
    ///
    func isEditable(_ isEditable: Bool) -> KTextView {
        var view = self
        view.isEditable = isEditable
        return view
    }

    /// Specifies whether the text can be selected
    ///
    /// - Parameter isSelectable: If true, the text can be selected.
    ///
    func isSelectable(_ isSelectable: Bool) -> KTextView {
        var view = self
        view.isSelectable = isSelectable
        return view
    }

    /// Specifies whether the field can be scrolled. If true, auto-sizing will be disabled,
    ///  and view will take as much as space that is available in its parent container,
    ///  unless you set specific height by using `.frame(height:)` modifier.
    ///  
    /// - Parameter isScrollingEnabled: If true, scrolling will be enabled
    ///
    func enableScrolling(_ isScrollingEnabled: Bool) -> KTextView {
        var view = self
        view.isScrollingEnabled = isScrollingEnabled
        return view
    }

    /// Specifies the type of return key to be shown during editing, for the device keyboard.
    ///
    /// - Parameter style: The return key style.
    ///
    func returnKey(_ style: UIReturnKeyType?) -> KTextView {
        var view = self
        view.returnKeyType = style
        return view
    }

    /// Specifies whether the return key should auto enable/disable based on the current text.
    ///
    /// - Parameter value: If true, when the text is empty the return key will be disabled.
    ///
    func automaticallyEnablesReturn(_ value: Bool?) -> KTextView {
        var view = self
        view.enablesReturnKeyAutomatically = value
        return view
    }

    /// Specifies the truncation mode for this field.
    ///
    /// - Parameter mode: The truncation mode of type `Text.TruncationMode`
    ///
    func truncationMode(_ mode: Text.TruncationMode) -> KTextView {
        var view = self
        switch mode {
        case .head: view.truncationMode = .byTruncatingHead
        case .tail: view.truncationMode = .byTruncatingTail
        case .middle: view.truncationMode = .byTruncatingMiddle
        @unknown default:
            view.truncationMode = .byTruncatingTail
        }
        return view
    }

    /// Specifies the truncation mode for this field.
    ///
    /// - Parameter mode: The truncation mode of type `NSLineBreakMode`
    ///
    func truncationMode(_ mode: NSLineBreakMode) -> KTextView {
        var view = self
        view.truncationMode = mode
        return view
    }
}
