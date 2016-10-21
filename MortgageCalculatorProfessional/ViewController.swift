//
//  ViewController.swift
//  MortgageCalculatorProfessional
//
//  Created by Alex on 10/20/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var propertyCost: UITextField!
    @IBOutlet weak var downPayment: UITextField!
    @IBOutlet weak var loanDuration: UITextField!
    @IBOutlet weak var interestRate: UITextField!
    @IBOutlet weak var propertyTax: UITextField!
    @IBOutlet weak var hoInsurance: UITextField!
    @IBOutlet weak var hoaFees: UITextField!
    @IBOutlet weak var otherFees: UITextField!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var monthlyPayment: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateMortgage(self)
    }

    @IBAction func calculateMortgage(_ sender: AnyObject) {
        if let pc = Double(propertyCost.text!) {
            if let dp = Double(downPayment.text!) {
                if let ld = Int(loanDuration.text!){
                    if let inr = Double(interestRate.text!){
                        let ir = Double(inr/Double(1200))
                        let C = pow(Double(1+ir),Double(ld*12))
                        let P = Double(pc-dp)
                        let F = ir*C
                        let S = C-1
                        var result:Double = 0
                        result = P * F/S
                        if let pt = Double(propertyTax.text!) {
                            result += pt*pc/1200
                        }
                        if let hoi = Double(hoInsurance.text!){
                            result += hoi
                        }
                        if let hoa = Double(hoaFees.text!){
                            result += hoa
                        }
                        if let other = Double(otherFees.text!){
                            result += other
                        }
                        
                        if result < 0 || ld <= 0 || inr <= 0 || P <= 0 || pc <= 0 || dp < 0 {
                            monthlyPayment.text = "Please enter valid values"
                            loanAmount.text = "Please enter valid values"
                        }
                        else {
                            loanAmount.text = "$\(String(format: "%.2f", P))"
                            monthlyPayment.text = "$\(String(format: "%.2f", result))"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

