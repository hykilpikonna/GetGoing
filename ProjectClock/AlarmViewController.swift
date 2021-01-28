import UIKit

class AlarmViewController: UIViewController
{
    @IBOutlet weak var table: UITableView!
    
    // TODO: Remove example and use localStorage
    var data: [Alarm] = [Alarm(alarmTime: Date(), text: "Wake up lol", wakeMethod: wvms[0])]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Assign table delegate and data source
        table.delegate = self
        table.dataSource = self
    }
}

/**
 Alarm table controller
 */
extension AlarmViewController: UITableViewDelegate, UITableViewDataSource
{
    /// How many sections are there
    func numberOfSections(in: UITableView) -> Int { return 1 }

    /// How many rows are there
    func tableView(_ v: UITableView, numberOfRowsInSection s: Int) -> Int { return data.count }

    /// Configure each cell
    func tableView(_ v: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
    {
        // Get the cell and item at index i
        let rawCell = v.dequeueReusableCell(withIdentifier: "alarm", for: i)
        guard let cell = rawCell as? AlarmTableCell else { return rawCell }
        let item = data[i.row]
    
        // Set the content of the cell to the content of the item.
        cell.setData(item)
        
        return cell
    }
    
    /// Define cell height
    func tableView(_ v: UITableView, heightForRowAt i: IndexPath) -> CGFloat { return 120 }
    
    /// IDK what this does (TODO: Find out what this does)
    func tableView(_ v: UITableView, didSelectRowAt i: IndexPath) { v.deselectRow(at: i, animated: true) }
}

/**
 Table cell that displays the information of each alarm.
 */
class AlarmTableCell: UITableViewCell
{
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var ampm: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var enable: UISwitch!
    @IBOutlet weak var repeatText: UILabel!
    @IBOutlet weak var goingOffText: UILabel!
<<<<<<< Updated upstream
=======
    @IBOutlet weak var wvmText: UILabel!
    @IBOutlet weak var toneLabel: UILabel!
    
>>>>>>> Stashed changes
    
    /// Update information on the cell to information in the alarm object
    func setData(_ alarm: Alarm)
    {
        descriptionText.text = "- " + alarm.text
<<<<<<< Updated upstream
=======
        enable.isOn = alarm.enabled
        wvmText.text = alarm.wakeMethod.name
        toneLabel.text = alarm.toneName
        
        // Display Hour, Minute, and AM or PM
        ampm.text = alarm.hour < 12 || alarm.hour == 24 ? "AM" : "PM"
        var hour = alarm.hour <= 12 ? alarm.hour : alarm.hour - 12
        hour = alarm.hour == 0 ? 12 : hour
        time.text = String(format: "%i:%02i", hour, alarm.minute)
       
        // displays the specific days alarm is activated
        let daysDict = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
        var daysActive : [String] = []
        if alarm.oneTime {repeatText.text = "One-time Alarm"}
        else {
            for (index, element) in alarm.repeats.enumerated() {
                if element {
                    daysActive.append(daysDict[index])
                }
            }
            if daysDict == daysActive {
                repeatText.text = "Repeats: Daily"
            } else if daysActive == ["Sun", "Sat"] {
                repeatText.text = "Repeats: Weekends"
            } else if daysActive == ["Mon", "Tues", "Wed", "Thurs", "Fri"] {
                repeatText.text = "Repeats: Weekdays"
            } else {
                repeatText.text = daysActive.joined(separator: ", ")
            }
        }
        
        updateActivationTime()
    }
    
    func updateActivationTime()
    {
        // Show next activation date
        if alarm.enabled, let n = alarm.nextActivate {
            goingOffText.text = "(Going off in \(n.timeIntervalSince(Date()).str()))"
        }
        else {
            goingOffText.text = ""
        }
    }
    
    /**
     Called when the user switches the switch
     */
    @IBAction func switchChange(_ sender: Any)
    {
        Alarms.fromLocal().apply {
            $0.list.first { $0.hour == self.alarm.hour && $0.minute == self.alarm.minute }?.enabled = enable.isOn
        }.localSave()
>>>>>>> Stashed changes
    }
}
