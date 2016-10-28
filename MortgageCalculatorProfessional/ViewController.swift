//
//  ViewController.swift
//  MortgageCalculatorProfessional
//
//  Created by Alex on 10/20/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var propertyCost: UITextField!
    @IBOutlet weak var downPayment: UITextField!
    @IBOutlet weak var loanDuration: UITextField!
    @IBOutlet weak var interestRate: UITextField!
    @IBOutlet weak var propertyTax: UITextField!
    @IBOutlet weak var mortgageInsurance: UITextField!
    @IBOutlet weak var hoInsurance: UITextField!
    @IBOutlet weak var hoaFees: UITextField!
    @IBOutlet weak var otherFees: UITextField!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var monthlyPayment: UILabel!
    @IBOutlet weak var totalPayment: UILabel!
    var toPrint: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        propertyCost.keyboardType = UIKeyboardType.decimalPad
        downPayment.keyboardType = UIKeyboardType.decimalPad
        loanDuration.keyboardType = UIKeyboardType.decimalPad
        interestRate.keyboardType = UIKeyboardType.decimalPad
        propertyTax.keyboardType = UIKeyboardType.decimalPad
        mortgageInsurance.keyboardType = UIKeyboardType.decimalPad
        hoInsurance.keyboardType = UIKeyboardType.decimalPad
        hoaFees.keyboardType = UIKeyboardType.decimalPad
        otherFees.keyboardType = UIKeyboardType.decimalPad
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
                        toPrint = ""
                        if let mi = Double(mortgageInsurance.text!){
                            result += mi*P/1200
                            toPrint += "Mortgage Insurance: " + String(mi)
                        }
                        let tmp = dp+result*Double(ld)*12.0
                        if let pt = Double(propertyTax.text!) {
                            result += pt*pc/1200
                            toPrint += "\nProperty Tax: " + String(pt)
                        }
                        if let hoi = Double(hoInsurance.text!){
                            result += hoi
                            toPrint += "\nHome Insurance: " + String(hoi)
                        }
                        if let hoa = Double(hoaFees.text!){
                            result += hoa
                            toPrint += "\nHOA Fees: " + String(hoa)
                        }
                        if let other = Double(otherFees.text!){
                            result += other
                            toPrint += "\nOther Fees: " + String(other)
                        }
                        
                        toPrint += "\n\nNeed to grind a few more numbers? Mortgage Calculator Professional+ is FREE: https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1168139016&mt=8"
                        
                        if result < 0 || ld <= 0 || inr <= 0 || P <= 0 || pc <= 0 || dp < 0 {
                            monthlyPayment.text = "Please enter valid values"
                            loanAmount.text = "Please enter valid values"
                            totalPayment.text = "Please enter valid values"
                        }
                        else {
                            loanAmount.text = "Loan Amount: $\(String(format: "%.2f", P))"
                            monthlyPayment.text = "Monthly Payment: $\(String(format: "%.2f", result))"
                            totalPayment.text = "Total Mortgage Payments: $\(String(format: "%.2f",tmp))"
                            toPrint = "------------------------\n\n" + toPrint
                            toPrint = totalPayment.text! + "\n" + toPrint
                            toPrint = loanAmount.text! + "\n" + toPrint
                            toPrint = monthlyPayment.text! + "\n" + toPrint
                            toPrint = "------------------------\n" + toPrint
                        }
                    }
                }
            }
        }
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func hideKeyboard(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject)
    {
        //Set the default sharing message.
        let message = toPrint
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

