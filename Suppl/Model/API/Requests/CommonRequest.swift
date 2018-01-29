import Foundation

class CommonRequest {
    
    private let defaultSession: URLSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    public func request(url: String, query: Dictionary<String, String>, taskCallback: @escaping (Error?, Data?) -> ()) {
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.query = toQuery(query)
        guard let url = urlComponents.url else { return }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            taskCallback(error, data)
            /* , let response = response as? HTTPURLResponse , response.statusCode == 200 */ 
        }
        dataTask?.resume()
    }
    
    private func toQuery(_ data: Dictionary<String, String>) -> String {
        var output: String = ""
        for (key,value) in data {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    
}
