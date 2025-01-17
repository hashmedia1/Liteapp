//
//  EmployeeOnboardingVCStep2.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit

class EmployeeOnboardingVCStep2:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    
    var saveEmployee:SaveEmployee!
    @IBOutlet weak var passwordValidationView: UIView!
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    
    @IBOutlet weak var emailTextValidationView: UIView!
    @IBOutlet weak var passwordTextValidationView: UIView!
    @IBOutlet weak var confirmPasswordTextValidationView: UIView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        txtPassword.delegate = self
        txtConfrimPassword.delegate = self
    }

    
    @IBAction func continueClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            
            saveEmployee.emp_password = txtPassword.text!
            saveEmployee.emp_work_email = txtEmail.text!
           
            
            let vc = EmployeeOnboardingVCStep3.instantiate()
            vc.saveEmployee = saveEmployee
            self.pushVC(controller:vc)
        }
    }
    func checkTextValidation(){
        if txtEmail.text!.count < 1{
            self.emailTextValidationView.isHidden = false
        }else{
            self.emailTextValidationView.isHidden = true
        }
        if txtPassword.text!.count < 1{
            self.passwordTextValidationView.isHidden = false
        }else{
            self.passwordTextValidationView.isHidden = true
        }
        if txtConfrimPassword.text!.count < 1{
            self.confirmPasswordTextValidationView.isHidden = false
        }else{
            self.confirmPasswordTextValidationView.isHidden = true
        }
       
       
    }
    func checkValidation()->Bool{
        if txtEmail.text!.count > 1{
            if txtEmail.text!.isEmail == false{
                self.showAlert(alertType:.validation, message: "Invalid E-mail. Please Try Again.")
                return false
            }
        }
        if txtPassword.text!.count < 1{
            return false
        }
        if txtConfrimPassword.text!.count < 1{
            return false
        }
        
        if txtPassword.text! != txtConfrimPassword.text!{
            self.showAlert(alertType:.validation, message: "Passwords do not match.")
            return false
        }
        return true
    }

}
extension EmployeeOnboardingVCStep2:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword{
            
            if let char = string.cString(using: String.Encoding.utf8) {
                   let isBackSpace = strcmp(char, "\\b")
                   if (isBackSpace == -92) {
                       print("Backspace was pressed")
                       self.updatePasswordValidation(str:String(textField.text?.dropLast() ?? ""))
                   }else{
                       self.updatePasswordValidation(str:textField.text! + string)
                   }
            }else{
                self.updatePasswordValidation(str:textField.text! + string)
            }
           
        } 
        return true
    }
    func updatePasswordValidation(str:String){
            if str == ""{
                imgvwminimumCharacter.image = UIImage.unselectedImage
                imgvwCapitalLetter.image = UIImage.unselectedImage
                imgvwLowercaseLetter.image = UIImage.unselectedImage
                imgvwNumber.image = UIImage.unselectedImage
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
         
            if str.count >= 8{
                imgvwminimumCharacter.image = UIImage.selectedImage
            }else{
                imgvwminimumCharacter.image = UIImage.unselectedImage
            }
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            if texttest.evaluate(with: str){
                imgvwCapitalLetter.image = UIImage.selectedImage
            }else{
                imgvwCapitalLetter.image = UIImage.unselectedImage
            }
          
            let lowercaseLetterRegEx  = ".*[a-z]+.*"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
             if texttest3.evaluate(with: str){
                 imgvwLowercaseLetter.image = UIImage.selectedImage
             }else{
                 imgvwLowercaseLetter.image = UIImage.unselectedImage
             }

           let numberRegEx  = ".*[0-9]+.*"
           let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            if texttest1.evaluate(with: str){
                imgvwNumber.image = UIImage.selectedImage
            }else{
                imgvwNumber.image = UIImage.unselectedImage
            }

           let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
           let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest2.evaluate(with: str){
                imgvwSpecialCharacter.image = UIImage.selectedImage
            }else{
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
        
    }
}
