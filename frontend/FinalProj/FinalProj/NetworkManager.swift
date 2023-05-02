//
//  NetworkManager.swift
//  finalproj
//
//  Created by Big Mac on 5/1/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    var url = URL(string: "https://34.85.172.228/")!

    func getAllEvents(completion: @escaping ([Event]) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(EventResponse.self, from: data)
                    completion(response.events)
                }
                catch (let error) {
                    print(error.localizedDescription)
                }
            }

        }
        task.resume()
    }

    func createEvent(nametext: String, starttime: String, endtime: String, loc: String, acc: String, descrip: String, completion: @escaping (Event) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "name": nametext,
            "start_time": starttime,
            "end_time": endtime,
            "location": loc,
            "access": acc,
            "description": descrip
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Event.self, from: data)
                    completion(response)
                }
                catch (let error) {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()

    }


}
