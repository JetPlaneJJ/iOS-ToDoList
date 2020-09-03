//
//  AutoFocusTextField.swift
//  ToDoListApp
//
//  Created by Jay Lin on 9/3/20.
//  Copyright © 2020 Jay Lin. All rights reserved.
//

import Foundation
import SwiftUI

struct AutoFocusTextField: UIViewRepresentable {
    
    class FocusCoordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var isResponder : Bool?
        
        init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = false
                if self.nextResponder != nil {
                    self.nextResponder = true
                }
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return true
        }
    }
    
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?
    @Binding var placeholder : String
    
    var isSecured : Bool = false
    var keyboard : UIKeyboardType
    
    func makeUIView(context: UIViewRepresentableContext<AutoFocusTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecured
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.delegate = context.coordinator
        
        textField.font = UIFont(name: "BRCandor-Bold", size: 18)
        textField.textColor = UIColor(red: 118/255, green: 70/255, blue: 254/255, alpha: 1.0)
        
        return textField
    }
    
    func makeCoordinator() -> AutoFocusTextField.FocusCoordinator {
        return FocusCoordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<AutoFocusTextField>) {
        uiView.text = text
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
}
