//
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
//

import Foundation

/// Base URL of the HTTP server
//let baseUrl = "https://alarm-clock-api.hydev.org"
let baseUrl = "http://192.168.0.12:8080"

/// Json class
class JSON
{
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static func stringify<T: Encodable>(_ o: T) -> String?
    {
        guard let jsonData = try? encoder.encode(o) else { return nil }
        return String(data: jsonData, encoding: String.Encoding.utf8)
    }
    
    static func parse<T: Decodable>(_ type: T.Type, _ j: String) -> T?
    {
        return try? decoder.decode(type, from: j.data(using: .utf8)!)
    }
}

/// Local storage
let localStorage = UserDefaults(suiteName: "group.org.hydev.alarm.clock")!

/// API class
struct API<T>
{
    let loc: String
}

/// Class to store static API endpoints
class APIs
{
    /**
     Register the user in the database.
     
     ## Parameters
     - username: The user's unique username
     - password: Password hash
     
     ## Returns
     Success or error
     */
    static let register = API<String>(loc: "/user/register")
    
    /**
     Verify password and login.
     
     ## Parameters
     - username: The user's unique username
     - password: Password hash
     
     ## Returns
     Success or error
     */
    static let login = API<String>(loc: "/user/login")
    
    /**
     Delete a user from the database.
     
     ## Parameters
     - username: The user's unique username
     - password: Password hash
     
     ## Returns
     Success or error
     */
    static let delete = API<String>(loc: "/user/delete")
    
    /**
     Upload curent config to the cloud.
     
     ## Parameters (Besides from username and password)
     - config: The config json
     
     ## Returns
     Success or error
     */
    static let uploadConfig = API<String>(loc: "/user/backup/upload")
    
    /**
     Download the config from the cloud.
     
     ## Parameters (Besides from username and password)
     None
     
     ## Returns
     Config Json
     */
    static let downloadConfig = API<String>(loc: "/user/backup/download")
    
    /**
     Get family info for this account
     
     ## Parameters (Besides from username and password)
     None
     
     ## Returns
     Family object
     */
    static let familyGet = API<Family>(loc: "/family/get")
    
    /**
     Create a family
     
     ## Parameters (Besides from username and password)
     - name: Family name
     - pin: Admin pin
     
     ## Returns
     Family object
     */
    static let familyCreate = API<Family>(loc: "/family/create")
    
    /**
     Change a family's admin pin
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - oldPin: Original admin pin
     - newPin: New admin pin
     
     ## Returns
     Updated family object
     */
    static let familyChangePin = API<Family>(loc: "/family/update_pin")
    
    /**
     Family-related action
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - pin: Admin pin
     - action: Join / Leave / Delete
     
     ## Returns
     Family object
     */
    static let familyAction = API<Family>(loc: "/family/action")
    
    /**
     Get updates about alarms that other family members added
     
     ## Parameters (Besides from username and password)
     None
     
     ## Returns
     Alarm updates
     */
    static let familyAlarmUpdates = API<String>(loc: "/family/get_alarm_updates")
    
    /**
     Add alarm to a family member
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - pin: Admin pin
     - to: Family member's username
     - alarm: Alarm json
     
     ## Returns
     Success message
     */
    static let familyAddAlarm = API<String>(loc: "/family/add_alarm")
    
    private init() {}
}

/**
 Build a URLRequest with the node path and params
 
 - Parameter api: API Node (Eg. APIs.register)
 - Parameter params: Parameters to send to the server (Check the documentation of the API node to see which parameters you need)
 - Returns: URLRequest
 */
func createRequest(_ node: String, _ params: [String: String]? = [:]) -> URLRequest
{
    // Create URL and request
    let url = URLComponents(string: baseUrl + node)
    var request = URLRequest(url: url!.url!)
    request.httpMethod = "POST"
    
    // Put parameters inside headers
    params?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
    
    return request
}

/**
 Send a HTTP request. Email and authentication token (the initial hash of a password) is automatically added if they exist in localStorage.
 
 - Parameter api: API Node (Eg. APIs.register)
 - Parameter params: Parameters to send to the server (Check the documentation of the API node to see which parameters you need)
 - Parameter success: Callback of what to do when the request successfully returned
 - Parameter err: Callback of what to do when an error happens
 */
func send<T: Decodable>(_ api: API<T>, _ params: [String: String]? = [:], _ success: @escaping (T) -> Void, err: @escaping (String) -> Void = {it in})
{
    // Add default params
    var params = params
    if params != nil
    {
        if params!["username"] == nil { params!["username"] = localStorage.string(forKey: "name") }
        if params!["password"] == nil { params!["password"] = localStorage.string(forKey: "pass") }
        if params!["fid"] == nil, let f = Family.fromLocal() { params!["fid"] = String(f.fid) }
    }
    
    // Create task
    let task = URLSession.shared.dataTask(with: createRequest(api.loc, params)) { (raw, response, error) in
        
        // Check if raw data exists
        guard let response = response as? HTTPURLResponse, let raw = raw else { err("Data doesn't exist"); return }
        
        // If success
        if (200...299).contains(response.statusCode)
        {
            // If the desired type is string, it doesn't have to parse json.
            if T.self == String.self, let msg = String(data: raw, encoding: .utf8) { success(msg as! T); return }
            
            // Parse JSON
            guard let obj = try? JSON.decoder.decode(T.self, from: raw) else { err("JSON cannot be parsed"); return }
            
            // Call callback
            success(obj)
        }
        
        // Failed
        else
        {
            let data = String(data: raw, encoding: .utf8) ?? "Error"
            err("\(response.statusCode) - \(data)")
        }
    }

    // Execute task
    task.resume()
}
