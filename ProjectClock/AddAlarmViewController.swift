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
    
    @IBOutlet weak var repeatWeekdaysSwitch: UISwitch!
    @IBOutlet weak var repeatWeekendsSwitch: UISwitch!
    @IBOutlet weak var alarmNameTextField: UITextField!
    

    // Pickers
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var wvmPicker: UIPickerView!
    
    @IBAction func defaultRingtonesButton(_ sender: Any) {
    }
    @IBAction func soundLibraryButton(_ sender: Any) {
    }
    
    @IBAction func addAlarmButton(_ sender: Any) {
        
        let (h, m, _) = timePicker.date.getHMS()
        let alarms = Alarms.fromLocal();
        alarms.list.append(
            Alarm(hour: h, minute: m, text: "\(alarmNameTextField.text) - \(h * m)", wakeMethod: wvms[0], lastActivate: Date().added(.minute, -1))
        )
        alarms.localSave()
        
        _ = navigationController?.popViewController(animated: true)
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
