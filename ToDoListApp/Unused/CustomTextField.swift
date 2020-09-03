//
//  CustomTextField.swift
//  takko
//
//  Created by Ying-Ying Lin on 5/4/20.
//  Copyright © 2020 yl. All rights reserved.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?
    @Binding var prevResponder: Bool?
    var isFirstTextField: Bool
    
    var isSecured : Bool = false
    var keyboard : UIKeyboardType
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecured
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.delegate = context.coordinator
        textField.textContentType = .oneTimeCode // automatic OTP insertion
        
        // Text Attributes
        textField.defaultTextAttributes.updateValue(59, forKey: NSAttributedString.Key.kern)
        textField.font = UIFont(name: "DroidSansMono", size: 30)
        textField.textColor = UIColor(red: 118/255, green: 70/255, blue: 254/255, alpha: 1.0)
        //        textField.textAlignment = .center
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var isResponder : Bool?
        @Binding var prevResponder: Bool?
        
        var isFirstTextField: Bool
        
        init(text: Binding<String>, nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>, prevResponder : Binding<Bool?>, isFirst: Bool) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
            _prevResponder = prevResponder
            isFirstTextField = isFirst
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async { self.isResponder = true }
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
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder, prevResponder: $prevResponder, isFirst: isFirstTextField)
    }
}

