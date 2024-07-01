//
//  ImageUtil.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 29/6/24.
//

import UIKit
import Photos

class ImageUtil {
    
    public static func checkPhotoPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            //user has previously granted access to the photo library
            completion(true)
        case .notDetermined:
            //user has not yet been asked for photo library access
            PHPhotoLibrary.requestAuthorization { newStatus in
                completion(newStatus == .authorized)
            }
        case .denied, .restricted:
            //user has previously denied or restricted access
            completion(false)
        @unknown default:
            //handle orther potential cases in the future updates
            completion(false)
        }
    }
    
    public static func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //user has previously granted access to the camera
            completion(true)
        case .notDetermined:
            //user has not yet been asked for camera access
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            //user has previously denied or restricted access
            completion(false)
        @unknown default:
            //handle orther pothential cases in the future updates
            completion(false)
        }
    }
    
    public static func saveImageAsJPEG(_ image: UIImage, to directory: FileManager.SearchPathDirectory, withName fileName: String, compressionQuality: CGFloat) -> URL? {
        //convert the UIImage to JPEG data with the specified compression quality
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            print("Error : Unable to convert UIImage to JPEG data")
            return nil
        }
        
        //get the URL of the specified directory
        let fileManager = FileManager.default
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            print("Error : Unable to access directory")
            return nil
        }
        
        //create the full file URL by appending the filename to the directory URL
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        //Write the data to the file
        do{
            try imageData.write(to: fileURL)
            print("Image successfully saved to \(fileURL)")
            return fileURL
        }catch{
            print("Error : Unable to write image data to file : \(error)")
            return nil
        }
    }
    
    public static func checkEqualImageScale(image: UIImage) -> Bool{
        return image.size.width == image.size.height 
    }
    
}
