//
//  FileManager+DocumentsDirectory.swift
//  WacthReactions WatchKit Extension
//
//  Created by Owen Henley on 05/05/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import Foundation

// Snippet
extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
