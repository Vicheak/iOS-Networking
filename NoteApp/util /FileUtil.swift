//
//  FileUtil.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 1/7/24.
//

import Foundation

class FileUtil {

    public static func deleteAllTmpFile() {
        let fileManager = FileManager.default
        let tmpURL = NSTemporaryDirectory()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(string: tmpURL)!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted file : \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error deleting files : \(error)")
        }
    }
  
    public static func deleteAllFileInDirectory(path: FileManager.SearchPathDirectory){
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: path, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted file : \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error deleting files : \(error)")
        }
    }
    
}
