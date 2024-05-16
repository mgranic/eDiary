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
    
    private let baseUrl = "http://192.168.1.80:5015/upload/"
    
    init(chapter: Chapter, eventList: [Event]) {
        self.chapter = chapter
        self.eventList = eventList
    }
    
    func uploadChapter() async {
        print(chapter.name)
        sendChapterDataToServer()
        
        // send data for all events to server
        for event in eventList {
            print(event.name)
            await sendEventDataToServer(event: event)
        }
    }
    
    func uploadImages(imgsData: [Data]) async {
        let response = await sendImagesToServer(imagesData: imgsData)
        
        print(response .statusCode)
    }
    
    /****************************************************** PRIVATE FUNCTIONS *****************************************************************/
    // send chapter data to server with classic HTTP POST request
    // this function does not send event data
    private func sendChapterDataToServer() {
        // Create a URL object for the GET request
        let url = URL(string: "\(baseUrl)createChapter")!
        
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
    
    // send event data to server using HTTP POST MULTIPART request
    private func sendEventDataToServer(event: Event) async {
        var multipart = MultipartRequest()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSSSSSSSZ"
        
        multipart.add(key: "name", value: event.name)
        multipart.add(key: "description", value: event.desc.isEmpty ? "_" : event.desc)
        multipart.add(key: "date", value: dateFormatter.string(from: event.date))
        
        if let image = event.image {
            // send real image attached to event
            multipart.add(
                key: "file",
                fileName: "image_\(event.id).jpg", //"pic.jpg",
                fileMimeType: "image/png",
                fileData: image
            )
        } else {
            // this event does not have image so send dummy data to satisfy request form
            multipart.add(
                key: "file",
                fileName: "dummy_pic.jpg",
                fileMimeType: "image/png",
                fileData: "fake-image-data".data(using: .utf8)!
            )
        }

        /// Create a regular HTTP URL request & use multipart components
        let url = URL(string: "\(baseUrl)uploadEvent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBody

        /// Fire the request using URL sesson or anything else...
        let (data, response) = try! await URLSession.shared.data(for: request)

        print((response as! HTTPURLResponse).statusCode)
        print(String(data: data, encoding: .utf8)!)
    }
    
    private func sendImagesToServer(imagesData: [Data]) async -> HTTPURLResponse {
        var multipart = MultipartRequest()
        var imgNum: Int = 0
        
        for imgData in imagesData {
            multipart.add(
                key: "files",
                fileName: "image_\(imgNum).jpg", //"pic.jpg",
                fileMimeType: "image/png",
                fileData: imgData)
            imgNum += 1
        }
        
        let url = URL(string: "\(baseUrl)UploadImages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBody

        /// Fire the request using URL sesson or anything else...
        let (data, response) = try! await URLSession.shared.data(for: request)
        
        return response as! HTTPURLResponse
    }
}
