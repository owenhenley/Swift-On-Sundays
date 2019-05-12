//
//  Document.swift
//  JustType
//
//  Created by Owen Henley on 12/05/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

class Document: UIDocument {

    var text: String = ""
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data(text.utf8)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        guard let contents = contents as? Data else {
            throw FileError.invalidData
        }
        text = String(decoding: contents, as: UTF8.self)
    }
}

