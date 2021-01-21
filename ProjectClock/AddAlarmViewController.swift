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
    
    // UI Elements
    @IBOutlet weak var repeatWeekdaysSwitch: UISwitch!
    @IBOutlet weak var repeatWeekendsSwitch: UISwitch!
    @IBOutlet weak var alarmNameTextField: UITextField!
    
    @IBAction func defaultRingtonesButton(_ sender: Any)
    {
        
    }
    
    @IBAction func soundLibraryButton(_ sender: Any)
    {
        
    }
    
    /**
     Called when the user clicks Add Alarm
     */
    @IBAction func addAlarmButton(_ sender: Any) {
        
        let (h, m, _) = timePicker.date.getHMS()
        
        // Create the alarm
        let alarm = Alarm(hour: h, minute: m,
                          text: alarmNameTextField.text ?? "Alarm",
                          wakeMethod: wvms[wvmPicker.selectedRow(inComponent: 0)],
                          lastActivate: Date())
        
        // TODO: Set alarm.repeats to correspond with what the user selects

        
        // Add the alarm to the list and save the list
        Alarms.fromLocal().apply { $0.list.append(alarm) }.localSave();

        // Dismiss this view
        self.dismiss(animated: true, completion: nil)
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
