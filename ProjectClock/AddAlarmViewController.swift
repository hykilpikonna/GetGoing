//
//  AddAlarmViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
// and Dallon :)

import UIKit

class AddAlarmViewController: UIViewController
{
    // UI: Make scroll view scrollable
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewInner: UIView!
    override func viewDidLayoutSubviews()
    {
        scrollView.addSubview(scrollViewInner)
        scrollView.contentSize = scrollViewInner.frame.size
    }
    
    // Pickers
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var wvmPicker: UIPickerView!
    
    @IBAction func defaultRingtonesButton(_ sender: Any) {
    }
    @IBAction func soundLibraryButton(_ sender: Any) {
    }
    @IBAction func repeatWeekdaysSwitch(_ sender: Any) {
    }
    @IBAction func repeatWeekendsSwitch(_ sender: Any) {
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}



class WVMDataSource: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        delegate = self
        dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ v: UIPickerView, numberOfRowsInComponent: Int) -> Int
    {
        return wvms.count
    }
    
    func pickerView(_ v: UIPickerView, titleForRow r: Int, forComponent: Int) -> String?
    {
        return wvms[r].name + " - " + wvms[r].desc
    }
}
