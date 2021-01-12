//
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
//

import Foundation

/// Base URL of the HTTP server
let baseUrl = "http://localhost:8080/api" // TODO: Production settings

/// API class
struct API<T>
{
    let loc: String
}

/// Class to store static API endpoints
class APIs
{
    static let register = API<String>(loc: "/user/register")
    static let delete = API<String>(loc: "/user/delete")
    
    private init() {}
}

/// Build a URL with the node path and params
func url(_ node: String, _ params: [String: String]? = [:]) -> URL
{
    var url = URLComponents(string: baseUrl + node)
    if let params = params
    {
        url?.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
    }
    return url!.url!
}

