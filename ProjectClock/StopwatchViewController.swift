//
//  StopwatchViewController.swift
//  ProjectClock
//
//  Created by Dallon Archibald on 1/23/21.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    var lappedTimes: [String] = []
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func start(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func count() {
        seconds += 1
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        if hours == 24 {
            timer.invalidate()
        }
        
        if seconds >= 10 { secondLabel.text = "\(seconds)" }
        else { secondLabel.text = "0\(seconds)" }
        if minutes >= 10 { minuteLabel.text = "\(minutes)" }
        else { minuteLabel.text = "0\(minutes)" }
        if hours >= 10 { hourLabel.text = "\(hours)" }
        else { hourLabel.text = "0\(hours)" }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        timer.invalidate()
    }
    
    @IBAction func reset(_ sender: UIButton) {
    }
    
    @IBAction func lap(_ sender: UIButton) {
        var currentSec = ""
        if seconds >= 10 { currentSec = "\(seconds)" }
        else { currentSec = "0\(seconds)" }
        
        var currentMin = ""
        if minutes >= 10 { currentMin = "\(minutes)" }
        else { currentMin = "0\(minutes)" }
        
        var currentHour = ""
        if hours >= 10 { currentHour = "\(hours)" }
        else { currentHour = "0\(hours)" }
        
        let currentTime = "\(currentHour):\(currentMin):\(currentSec)" //CHECK THIS
        lappedTimes.append(currentTime)
        
        let indexPath = IndexPath(row: lappedTimes.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lappedTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = lappedTimes[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lappedTimes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
