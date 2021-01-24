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
    @IBOutlet weak var timeTillAlarmLabel: UILabel!
    
    @IBAction func defaultRingtonesButton(_ sender: Any)
    {
        
    }
    
    @IBAction func soundLibraryButton(_ sender: Any)
    {
        
    }
    
    /**
    Called when the time for the alarm is changed.
        Sets the time away at the top of the View.
     */
    @IBAction func alarmTimeUpdated(_ sender: Any) {
        updateETA()
    }
    
    
    /**
     Called when the user clicks the remove button and brings them back to the home page
     */
    @IBAction func cancelAlarmButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //might need to reset all UI elements
    }
    
    /**
     Called when the user clicks Add Alarm
     */
    @IBAction func addAlarmButton(_ sender: Any)
    {
        let (h, m, _) = timePicker.date.getHMS()
     
        // Check for existing alarm
        if (Alarms.fromLocal().list.contains { $0.hour == h && $0.minute == m })
        {
            msg("Nope", "You already have an alarm at " + String(format: "%i:%02i", h, m))
            return
        }
        
        // Create the alarm
        let alarm = Alarm(hour: h, minute: m,
                          text: alarmNameTextField.text ?? "Alarm",
                          wakeMethod: wvms[wvmPicker.selectedRow(inComponent: 0)],
                          lastActivate: Date())
        
        // Set alarm.repeats to correspond with what the user selects
        (0...6).forEach { alarm.repeats[$0] = false }
        if repeatWeekdaysSwitch.isOn { (1...5).forEach { alarm.repeats[$0] = true } }
        if repeatWeekendsSwitch.isOn { [0, 6].forEach { alarm.repeats[$0] = true } }
        
        // Add the alarm to the list and save the list
        Alarms.fromLocal().apply { $0.list.append(alarm) }.localSave();

        // Dismiss this view
        self.dismiss(animated: true, completion: nil)
    }
    
    // Dynamically the ETA label for the alarm
    func updateETA() {
        //Create alarm without adding it to the queue.
        let (h, m, _) = timePicker.date.getHMS()
     
        // Create the alarm
        let a = Alarm(hour: h, minute: m,
                          text: alarmNameTextField.text ?? "Alarm",
                          wakeMethod: wvms[wvmPicker.selectedRow(inComponent: 0)],
                          lastActivate: Date())
        // Set alarm.repeats to correspond with what the user selects
        (0...6).forEach { a.repeats[$0] = false }
        if repeatWeekdaysSwitch.isOn { (1...5).forEach { a.repeats[$0] = true } }
        if repeatWeekendsSwitch.isOn { [0, 6].forEach { a.repeats[$0] = true } }
        
        let timeTill = a.nextActivate!.timeIntervalSince(Date()).str()
        //print(timeTill)
        timeTillAlarmLabel.text = "Going off in \(timeTill)"
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
