//
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
//

import Foundation

/// Base URL of the HTTP server
let baseUrl = "https://alarm-clock-api.hydev.org"

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
    static let uploadConfig = API<String>(loc: "/backup/upload")
    
    /**
     Download the config from the cloud.
     
     ## Parameters (Besides from username and password)
     None
     
     ## Returns
     Config Json
     */
    static let downloadConfig = API<String>(loc: "/backup/download")
    
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
     Delete a family
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - pin: Admin pin
     
     ## Returns
     Success or not
     */
    static let familyDelete = API<String>(loc: "/family/delete")
    
    /**
     Change a family's admin pin
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - orig_pin: Original admin pin
     - new_pin: New admin pin
     
     ## Returns
     Success or not
     */
    static let familyChangePin = API<String>(loc: "/family/update_pin")
    
    /**
     Join family
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - pin: Admin pin
     
     ## Returns
     Family object
     */
    static let familyJoin = API<Family>(loc: "/family/join")
    
    /**
     Leave family
     
     ## Parameters (Besides from username and password)
     - fid: Family ID
     - pin: Admin pin
     
     ## Returns
     Success or not
     */
    static let familyLeave = API<String>(loc: "/family/leave")
    
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
