//
//  AddAlarmViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
// and Dallon :)

import UIKit

class AddAlarmViewController: UIViewController
{
<<<<<<< Updated upstream
=======
    // Editing variables
    var alarmCell: AlarmTableCell? = nil
    var editMode: Bool { alarmCell != nil }
    var originalTime: String = ""
    
    override func viewDidLoad()
    {
        // End edit on return
        alarmNameTextField.delegate = self
        
        // Load alarm to edit if in edit mode
        if let alarmCell = alarmCell
        {
            // Toggle editing mode
            viewTitle.text = "Edit Alarm"
            
            // Convert string to Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mma"
            let date = dateFormatter.date(from: "\(alarmCell.time.text!)\(alarmCell.ampm.text!)")
            
            // Set all the original values to be edited
            timePicker.date = date!
            originalTime = String(dateFormatter.string(from: date!).dropLast(2))
            
            // Toggle proper repeats
            if let repeats = alarmCell.repeatText.text {
                if repeats == "Repeats: Weekdays" {
                    repeatWeekdaysSwitch.isOn = true
                    repeatWeekendsSwitch.isOn = false
                } else if repeats == "Repeats: Weekends" {
                    repeatWeekendsSwitch.isOn = true
                    repeatWeekdaysSwitch.isOn = false
                } else if repeats == "Repeats: Daily" {
                    repeatWeekdaysSwitch.isOn = true
                    repeatWeekendsSwitch.isOn = true
                } else {
                    repeatWeekendsSwitch.isOn = false
                    repeatWeekdaysSwitch.isOn = false
                }
            }
            
            alarmNameTextField.text = String(alarmCell.descriptionText.text!.dropFirst(2))
            updateETA()
            
            // Sets the WVM
            if let wvm = alarmCell.wvmText.text {
                for index in 0...wvms.count-1 {
                    if wvm == wvms[index].name {
                        wvmPicker.selectRow(index, inComponent: 0, animated: true)
                    }
                }
            }
            
            //Sets alarm tone
            if let toneName = alarmCell.toneLabel.text {
                for index in 0...ringtones.count-1 {
                    if toneName == ringtones[index].name {
                        ringtonePicker.selectRow(index, inComponent: 0, animated: true)
                    }
                }
            }
        }
    }
    
>>>>>>> Stashed changes
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
    
    override func viewDidLoad()
    {
<<<<<<< Updated upstream
        super.viewDidLoad()
=======
        let (h, m, _) = timePicker.date.getHMS()
        
        // Create the alarm
        let alarm = Alarm(hour: h, minute: m,
                          text: alarmNameTextField.text ?? "Alarm",
                          wakeMethod: wvms[wvmPicker.selectedRow(inComponent: 0)],
                          lastActivate: Date(), alarmTone: ringtones[ringtonePicker.selectedRow(inComponent: 0)].tone, toneName: ringtones[ringtonePicker.selectedRow(inComponent: 0)].name)
        
        // Set alarm.repeats to correspond with what the user selects
        (0...6).forEach { alarm.repeats[$0] = false }
        if repeatWeekdaysSwitch.isOn { (1...5).forEach { alarm.repeats[$0] = true } }
        if repeatWeekendsSwitch.isOn { [0, 6].forEach { alarm.repeats[$0] = true } }
        
        return alarm
    }
    
    /**
     Dynamically the ETA label for the alarm
     */
    func updateETA() {
        let timeTill = createAlarm().nextActivate!.timeIntervalSince(Date()).str()
        timeTillAlarmLabel.text = "Going off in \(timeTill)"
>>>>>>> Stashed changes
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
