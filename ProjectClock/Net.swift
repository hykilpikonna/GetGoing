//
//  ProjectClock
//
//  Created by Hykilpikonna on 1/8/21.
//

import Foundation

let baseUrl = "http://localhost:8080/api/" // TODO: Production settings

/// Build a URL with the node path and params
func buildUrl(_ node: String, _ params: [String: String]?) -> URL
{
    var url = URLComponents(string: baseUrl + node)
    if let params = params
    {
        url?.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
    }
    return url!.url!
}

