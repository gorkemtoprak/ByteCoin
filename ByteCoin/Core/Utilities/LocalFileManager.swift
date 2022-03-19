//
//  LocalFileManager.swift
//  ByteCoin
//
//  Created by GT on 17.03.2022.
//

import Foundation
import SwiftUI

class LocalFileManager{
    
    static let instance = LocalFileManager()
    
    private init(){
        
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        
        // create folder
        createFolder(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData(),
            let url = getImageURL(imageName: imageName, folderName: folderName)
            else { return }
        
        // save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error occured when saving the image \(error)")
        }
    }
    
    func getImage(image: String, folderName: String) -> UIImage?{
        guard
            let url = getImageURL(imageName: image, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolder(folderName: String){
        guard let folderURL = getFolderURL(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: folderURL.path){
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error while creating a folder \(error)")
            }
        }
    }
    
    private func getFolderURL(folderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func getImageURL(imageName: String, folderName: String) -> URL?{
        guard let folderURL = getFolderURL(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
