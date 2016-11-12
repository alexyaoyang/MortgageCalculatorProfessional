//
//  ViewController.swift
//  MortgageCalculatorProfessional
//
//  Created by Alex on 10/20/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, ARPieChartDelegate, ARPieChartDataSource {

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
    
    @IBOutlet weak var pieChart: ARPieChart!
    @IBOutlet weak var selectionLabel: UILabel!
    var dataItems: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.showDescriptionText = true
        
        let maxRadius = min(pieChart.frame.width, pieChart.frame.height) / 2
        pieChart.innerRadius = CGFloat(maxRadius*0.4)
        pieChart.outerRadius = CGFloat(maxRadius*0.9)
        pieChart.selectedPieOffset = CGFloat(maxRadius*0.2)
        
        selectionLabel.text = ""
        selectionLabel.numberOfLines = 2
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pieChart.reloadData()
    }
    
    @IBAction func calculateMortgage(_ sender: AnyObject) {
        dataItems = []
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
                        var temp:Double = 0
                        result = P * F/S
                        toPrint = ""
                        
                        dataItems.add(PieChartItem(value: CGFloat(result), color: UIColor.red, description: "Mortgage"))
                        
                        if let mi = Double(mortgageInsurance.text!){
                            temp = mi*P/1200
                            result += temp
                            toPrint += "Mortgage Insurance: " + String(mi) + "% = $" + String(format: "%.2f", temp)
                            dataItems.add(PieChartItem(value: CGFloat(temp), color: UIColor.blue, description: "Mort. Ins."))
                        }
                        let tmp = dp+result*Double(ld)*12.0
                        if let pt = Double(propertyTax.text!) {
                            temp = pt*pc/1200
                            result += temp
                            toPrint += "\nProperty Tax: " + String(pt) + "% = $" + String(format: "%.2f", temp)
                            dataItems.add(PieChartItem(value: CGFloat(temp), color: UIColor.black, description: "Prop. Tax"))
                        }
                        if let hoi = Double(hoInsurance.text!){
                            result += hoi
                            toPrint += "\nHome Insurance: $" + String(hoi)
                            dataItems.add(PieChartItem(value: CGFloat(hoi), color: UIColor.brown, description: "Home Ins."))
                        }
                        if let hoa = Double(hoaFees.text!){
                            result += hoa
                            toPrint += "\nHOA Fees: $" + String(hoa)
                            dataItems.add(PieChartItem(value: CGFloat(hoa), color: UIColor.darkGray, description: "HOA Fees"))
                        }
                        if let other = Double(otherFees.text!){
                            result += other
                            toPrint += "\nOther Fees: $" + String(other)
                            dataItems.add(PieChartItem(value: CGFloat(other), color: UIColor.purple, description: "Other Fees"))
                        }
                        
                        toPrint += "\n\nNeed to grind a few more numbers? Mortgage Calculator App is FREE: https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1168139016&mt=8"
                        
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
        pieChart.reloadData()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
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
    
    /**
     *  MARK: ARPieChartDelegate
     */
    func pieChart(_ pieChart: ARPieChart, itemSelectedAtIndex index: Int) {
        let itemSelected: PieChartItem = dataItems[index] as! PieChartItem
        selectionLabel.text = itemSelected.description! + "\n$\(String(format: "%.2f",itemSelected.value))"
        selectionLabel.textColor = itemSelected.color
    }
    
    func pieChart(_ pieChart: ARPieChart, itemDeselectedAtIndex index: Int) {
        selectionLabel.text = ""
        selectionLabel.textColor = UIColor.black
    }
    
    
    /**
     *   MARK: ARPieChartDataSource
     */
    func numberOfSlicesInPieChart(_ pieChart: ARPieChart) -> Int {
        return dataItems.count
    }
    
    func pieChart(_ pieChart: ARPieChart, valueForSliceAtIndex index: Int) -> CGFloat {
        let item: PieChartItem = dataItems[index] as! PieChartItem
        return item.value
    }
    
    func pieChart(_ pieChart: ARPieChart, colorForSliceAtIndex index: Int) -> UIColor {
        let item: PieChartItem = dataItems[index] as! PieChartItem
        return item.color
    }
    
    func pieChart(_ pieChart: ARPieChart, descriptionForSliceAtIndex index: Int) -> String {
        let item: PieChartItem = dataItems[index] as! PieChartItem
        return item.description ?? ""
    }
}

/**
 *  MARK: Pie chart data item
 */
open class PieChartItem {
    
    /// Data value
    open var value: CGFloat = 0.0
    
    /// Color displayed on chart
    open var color: UIColor = UIColor.black
    
    /// Description text
    open var description: String?
    
    public init(value: CGFloat, color: UIColor, description: String?) {
        self.value = value
        self.color = color
        self.description = description
    }
}
