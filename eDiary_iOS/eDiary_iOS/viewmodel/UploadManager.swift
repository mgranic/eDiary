//
//  UploadManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 27.03.2024..
//

import Foundation

class UploadManager {
    var chapter: Chapter;
    var eventList: [Event]
    
    init(chapter: Chapter, eventList: [Event]) {
        self.chapter = chapter
        self.eventList = eventList
    }
    
    func uploadChapter() async {
        print(chapter.name)
        sendChapterDataToServer()
        await sendEventDataToServer(event: Event(chapterId: UUID(), name: "ime", description: "opis", date: Date()))
        
        for event in eventList {
            print(event.name)
        }
    }
    
    /****************************************************** PRIVATE FUNCTIONS *****************************************************************/
    private func sendChapterDataToServer() {
        // Create a URL object for the GET request
        let url = URL(string: "http://192.168.1.80:5015/chapter/createChapter")!
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSSSSSSSZ"
        
        // Create a URLRequest object
        var request = URLRequest(url: url)
        
        // Set the HTTP method to GET
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonObject: [String: Any] = ["id": 1, "userId": chapter.userId ?? 1, "name": chapter.name, "desc": chapter.desc, "date": dateFormatter.string(from: chapter.date)]
        //let jsonObject: [String: Any] = ["id": 1, "userId": chapter.userId ?? 1, "name": chapter.name, "desc": chapter.desc, "date": "2024-04-15T13:09:02.596000000"]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
        print(String(data: jsonData, encoding: .utf8))
        request.httpBody = jsonData
        
        //let jsonEncoder = JSONEncoder()
        //let chapterJson = try! jsonEncoder.encode(chapter)
        //let chapterJsonString = String(data: chapterJson, encoding: .utf8)
        //print(chapterJsonString)
        //request.httpBody = chapterJson
        
        //let jsonData = try! JSONSerialization.data(withJSONObject: chapter, options: [])
        //request.httpBody = jsonData
        
        // Make the HTTP request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            // Check the response status code
            if response.statusCode != 200 {
                print("*****************************************************************")
                print("HTTP status code: \(response.statusCode)")
                print("*****************************************************************")
                return
            }
            
            // Get the response data
            print(String(data: data!, encoding: .utf8)!)
            //motivationalQuote = String(data: data!, encoding: .utf8)!
            //let value = responseString.substring(from: 9)
            //let x = data!
            //print(motivationalQuote)
            
        }.resume()
    }
    
    private func sendEventDataToServer(event: Event) async {
        var multipart = MultipartRequest()
        for field in [
            "description": "John"
        ] {
            multipart.add(key: field.key, value: field.value)
        }

        multipart.add(
            key: "file",
            fileName: eventList.first?.image!.description ?? "pic.jpg",
            fileMimeType: "image/png",
            fileData: eventList.first?.image! ?? "fake-image-data".data(using: .utf8)!
            //fileData: "fake-image-data".data(using: .utf8)!
        )

        /// Create a regular HTTP URL request & use multipart components
        let url = URL(string: "http://192.168.1.80:5015/upload/uploadEvent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBody

        /// Fire the request using URL sesson or anything else...
        let (data, response) = try! await URLSession.shared.data(for: request)

        print((response as! HTTPURLResponse).statusCode)
        print(String(data: data, encoding: .utf8)!)
    }
}
