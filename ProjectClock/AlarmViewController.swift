import UIKit

class AlarmViewController: UIViewController
{
    @IBOutlet weak var table: UITableView!
    static var staticTable: UITableView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Assign table delegate and data source
        AlarmViewController.staticTable = table
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
    func tableView(_ v: UITableView, numberOfRowsInSection s: Int) -> Int { return Alarms.fromLocal().list.count }

    /// Configure each cell
    func tableView(_ v: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
    {
        // Get the cell and item at index i
        let rawCell = v.dequeueReusableCell(withIdentifier: "alarm", for: i)
        guard let cell = rawCell as? AlarmTableCell else { return rawCell }
        let item = Alarms.fromLocal().list[i.row]
    
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
    
    /// Update information on the cell to information in the alarm object
    //WARNING:Terrible code lies ahead! You WILL be dissapointed! But it works, and that is all that matters.

    func setData(_ alarm: Alarm)
    {
        descriptionText.text = "- " + alarm.text
        ampm.text = alarm.hour<12 || alarm.hour==24 ? "AM":"PM"
        if alarm.hour > 12{
            alarm.hour -= 12
        }
        time.text = alarm.minute<10 ? "\(alarm.hour)" + ":" + "0" + "\(alarm.minute)":"\(alarm.hour)" + ":" + "\(alarm.minute)"
       
        // displays the specific days alarm is activated
        let daysDict = [0: "Mon", 1: "Tues", 2: "Wed", 3: "Thurs", 4: "Fri", 5: "Sat", 6: "Sun"]
        var daysActive : [String] = []
        if alarm.oneTime {repeatText.text = "No Repeat"}
        else{
            for (index, element) in alarm.repeats.enumerated(){
                if element{
                    daysActive.append(daysDict[index] ?? "")
                }
            }
            repeatText.text = daysActive.joined(separator: ", ")
        }
        if alarm.enabled, let n = alarm.nextActivate{
            goingOffText.text = "(Going off in \(n.timeIntervalSince(Date()).str()))"
        }
    }
}
