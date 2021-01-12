//
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
//

import Foundation

/// Base URL of the HTTP server
let baseUrl = "http://localhost:8080/api" // TODO: Production settings
let JSON = JSONDecoder()

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
     - name: The user's name (this is not username because it doesn't have to be unique)
     - email: The user's email (this does have to be unique)
     - pass: Password (initial hash)
     
     ## Returns
     Success or error
     */
    static let register = API<String>(loc: "/user/register")
    
    /**
     Delete a user from the database.
     
     ## Parameters
     - email: The user's email
     - pass: Password (initial hash)
     
     ## Returns
     Success or error
     */
    static let delete = API<String>(loc: "/user/delete")
    
    private init() {}
}

/// Build a URL with the node path and params
func createUrl(_ node: String, _ params: [String: String]? = [:]) -> URL
{
    var url = URLComponents(string: baseUrl + node)
    if let params = params
    {
        url?.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
    }
    return url!.url!
}

/**
 Send a HTTP request
 
 - Parameter api: API Node (Eg. APIs.register)
 - Parameter params: Parameters to send to the server (Check the documentation of the API node to see which parameters you need)
 - Parameter success: Callback of what to do when the request successfully returned
 - Parameter err: Callback of what to do when an error happens
 */
func send<T: Decodable>(_ api: API<T>, _ params: [String: String]? = [:], _ success: @escaping (T) -> Void, err: @escaping (String) -> Void = {it in})
{
    let url = createUrl(api.loc, params)
    
    // Create task
    let task = URLSession.shared.dataTask(with: url) { (raw, response, error) in
        
        // Check if raw data exists
        guard let response = response as? HTTPURLResponse, let raw = raw else { err("Data doesn't exist"); return }
        
        // If success
        if (200...299).contains(response.statusCode)
        {
            // Parse JSON
            guard let obj = try? JSON.decode(T.self, from: raw) else { err("JSON cannot be parsed"); return }
            
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
