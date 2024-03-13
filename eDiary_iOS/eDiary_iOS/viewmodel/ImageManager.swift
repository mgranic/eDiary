//
//  ImageManager.swift
//  eDiary_iOS
//
//  Created by Mate Granic on 16.03.2024..
//

import Foundation
import PhotosUI
import SwiftUI

class ImageManager {
    
    func photosPickerToData(img: PhotosPickerItem?) async -> Data? {
        
        if let image = img {
            do {
                return try await image.loadTransferable(type: Data.self)
            } catch {
                return nil
            }
            
        }
        
        return nil
    }
    
    func imageDataToImage(imgData: Data?) -> Image? {
        if let imageData = imgData {
            if let image = UIImage(data: imageData) {
                return Image(uiImage: image)
            }
        }
        return nil
    }
}
