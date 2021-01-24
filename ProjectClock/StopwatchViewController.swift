//
//  StopwatchViewController.swift
//  ProjectClock
//
//  Created by Dallon Archibald on 1/23/21.
//  Reference: https://youtu.be/H691qFRpaWA

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
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

        //lapButton.isHidden = true
    }
    
    @IBAction func start(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
        //startButton.isHidden = true
        //lapButton.isHidden = false
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
            resetTimes()
        }
        
        timeLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func stop(_ sender: UIButton) {
        timer.invalidate()
        //startButton.isHidden = false
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetTimes()
    }
    
    func resetTimes() {
        seconds = 0
        minutes = 0
        seconds = 0
        lappedTimes = []
        timer.invalidate()
        timeLabel.text = "00:00:00"
        tableView.reloadData()
        //startButton.isHidden = false
        //lapButton.isHidden = true
    }
    
    @IBAction func lap(_ sender: UIButton) {
        lappedTimes.append(String(format: "%02i:%02i:%02i", hours, minutes, seconds))
        
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

/**
 Class to set relative font size for the stopwatch
 */
class StopwatchText: UILabel
{
    @IBInspectable var iPhoneFontSize: CGFloat = 0
    {
        didSet
        {
            overrideFontSize(iPhoneFontSize)
        }
    }

    func overrideFontSize(_ fontSize: CGFloat)
    {
        let size = UIScreen.main.bounds.size
        let width = UIDevice.current.orientation.isPortrait ? size.width : size.height
        
        // ViewWidth-based font size
        font = font.withSize(0.22 * width)
    }
}
