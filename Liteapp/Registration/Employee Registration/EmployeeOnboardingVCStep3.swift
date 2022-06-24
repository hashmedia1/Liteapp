//
//  EmployeeOnboardingVCStep3.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit
import Alamofire
import ObjectMapper

class EmployeeOnboardingVCStep3:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtReferralCode: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    var saveEmployee:SaveEmployee!
    override func viewDidLoad() {
        super.viewDidLoad()

        txtReferralCode.delegate = self
        txtCompany.isUserInteractionEnabled = false
    }
    
    @IBAction func continueClicked(sender:UIButton){
        if checkValidation(){
            
            self.saveEmployeeapiCall()
        }
    }
    func checkValidation()->Bool{
       
        return true
    }
    func saveEmployeeapiCall(){
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.saveEmployees(), param: self.saveEmployee.getParam()) { success, response, error in
            if let res = response{
                print(res)
                let user = Mapper<EmployeeData>().map(JSONObject:res)
                Defaults.shared.currentUser = user?.empData?.first
                print(Defaults.shared.currentUser?.merchantName ?? "")
                if let empType = Defaults.shared.currentUser?.empType{
                    if empType == "E"{
                        let vc = DashBoardVC.instantiate()
                        self.pushVC(controller:vc)
                    }else if empType == "S"{
                        
                    }
                }
            }else if let err = error{
                print(err)
            }
        }
    }
    func checkRefferalCode(_ code:String){
        let header = Defaults.shared.header ?? ["":""]
        let parameter = ["merchant_reference_number":"\(code)"]
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.searchMerchantsByRef(), param: parameter, header: header) { success, response, error in
            if let res = response{
                let data = Mapper<MerchantCodeData>().map(JSONObject:res)
                print(data?.toJSON() ?? "")
                self.txtCompany.text = data?.data?.first?.merchantName ?? ""
                self.saveEmployee.merchant_id = "\(data?.data?.first?.merchantId ?? 0)"
                print(self.saveEmployee.getParam())
            }else if let err = error{
                print(err)
            }
            
        }
    }
    
}
extension EmployeeOnboardingVCStep3:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtReferralCode{
            if textField.text!.count == 4{
                return false
            }else if textField.text!.count == 3{
                let code = self.txtReferralCode.text! + string
                self.checkRefferalCode(code)
            }
            return true
        }
        return true
    }
}
