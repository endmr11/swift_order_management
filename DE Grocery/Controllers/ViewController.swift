//
//  ViewController.swift
//  DE Grocery
//
//  Created by Eren Demir on 20.05.2022.
//

import UIKit

class ViewController: UIViewController {
    var showPassword = false
    var isLight:Bool = true
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var passTextField: UITextField! {
        didSet{
            passTextField.rightView = showPassBtn
            passTextField.rightViewMode = .always
        }
    }
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var themeBtn: UIBarButtonItem!
    @IBOutlet weak var languageBtn: UIBarButtonItem!
    
    
    var showPassBtn: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.frame = CGRect(x: CGFloat(passTextField.frame.size.width - 40), y: CGFloat(5), width: CGFloat(40), height: CGFloat(30))
        button.addTarget(self, action: #selector(self.refreshContent), for: .touchUpInside)
        return button
    }
    
    var hidePassBtn: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        button.frame = CGRect(x: CGFloat(passTextField.frame.size.width - 40), y: CGFloat(5), width: CGFloat(40), height: CGFloat(30))
        button.addTarget(self, action: #selector(self.refreshContent), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userLoggedIn:Bool? = LocaleDatabaseHelper().isLoggedIn
        let userType:Int? = LocaleDatabaseHelper().currentUserType
        isLight = LocaleDatabaseHelper().isLight ?? true
        let light = LocaleDatabaseHelper().isLight ?? true
        self.overrideUserInterfaceStyle = light ? .light : .dark
        self.themeBtn.image = light ? UIImage(systemName: "sun.min"): UIImage(systemName: "moon")
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if let isLoggedIn = userLoggedIn {
            if isLoggedIn {
                if let uType = userType {
                    switch uType {
                    case 0:
                        self.performSegue(withIdentifier: "toMainPage", sender: nil)
                    case 1:
                        self.performSegue(withIdentifier: "toOrdersPage", sender: nil)
                    default:
                        print("???")
                    }
                }
            }
        }
    }
    
    @objc func refreshContent() {
        showPassword.toggle()
        passTextField.rightView = showPassword ? showPassBtn : hidePassBtn
        passTextField.isSecureTextEntry = showPassword
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainPage" {
            print("toMainPage")
        }else if segue.identifier == "toOrdersPage" {
            print("toOrdersPage")
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        if let mail = mailTextfield.text, let pass = passTextField.text{
            APIService().login(model: LoginRequestModel(email: mail, password: pass),onSuccess: { value in
                if let status = value.status {
                    if status == 200 {
                        DispatchQueue.main.async {
                            self.setSession(data: value.model?.first)
                            self.mailTextfield.text = ""
                            self.passTextField.text = ""
                            switch value.model?.first?.user_type {
                            case 0:
                                self.performSegue(withIdentifier: "toMainPage", sender: nil)
                            case 1:
                                self.performSegue(withIdentifier: "toOrdersPage", sender: nil)
                            default:
                                print("???")
                            }
                        }
                    }
                }
            })
        }
        
    }
    
    
    @IBAction func changeTheme(_ sender: Any) {
        if #available(iOS 13.0, *){
            self.isLight.toggle()
            if self.isLight {
                self.themeBtn.image = UIImage(systemName: "sun.min")
                overrideUserInterfaceStyle = .light
                LocaleDatabaseHelper().setCurrentUserTheme(isLight: true)
            }else{
                self.themeBtn.image = UIImage(systemName: "moon")
                overrideUserInterfaceStyle = .dark
                LocaleDatabaseHelper().setCurrentUserTheme(isLight: false)
            }

        }
    }
    
    
    @IBAction func changeLanguage(_ sender: Any) {
    }
    
    func setSession(data:LoginModel?){
        if let model = data {
            LocaleDatabaseHelper().setCurrentUserMail(userEmail: model.email)
            LocaleDatabaseHelper().setCurrentUserType(userType: model.user_type)
            LocaleDatabaseHelper().setCurrentUserId(userId: model.id)
            LocaleDatabaseHelper().setCurrentUserLoggedIn(loggedIn: true)
            LocaleDatabaseHelper().setCurrentUserName(userName: model.name)
            LocaleDatabaseHelper().setCurrentUserSurname(userSurname: model.surname)
            LocaleDatabaseHelper().setCurrentUserToken(token: model.token)
        }
    }
    
    
}



/*
 let notificationCenter = NotificationCenter.default
 
 let keyboardWillShowObserver: NSObjectProtocol = notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
 guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
 let height = value.cgRectValue.height
 }
 
 let keyboardWillHideObserver: NSObjectProtocol = notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
 print("Z")
 }
 
 
 */
