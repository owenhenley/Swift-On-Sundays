//
//  DocumentViewController.swift
//  JustType
//
//  Created by Owen Henley on 12/05/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Sourceful

class DocumentViewController: UIViewController, SyntaxTextViewDelegate {

    @IBOutlet var textView: SyntaxTextView!

    var document: Document?
    let lexer = SwiftLexer()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textView.theme = DefaultSourceCodeTheme()
        textView.delegate = self

        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDocumentViewController)),
                                         animated: true)
        
        // Access the document
        document?.open { success in
            if success {
                // Display the content of the document, e.g.:
                self.textView.text = self.document?.text ?? ""
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        }
    }
    
    @objc func dismissDocumentViewController() {
        document?.text = textView.text
        document?.updateChangeCount(.done)
        self.title = self.document?.fileURL.deletingPathExtension().lastPathComponent
        dismiss(animated: true) {
            self.document?.close()
        }
    }

    @objc func shareTapped (sender: UIBarButtonItem) {
        guard let url = document?.fileURL else {
            return
        }

        let ac = UIActivityViewController(activityItems: [url], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = sender
        present(ac, animated: true)
    }

    func lexerForSource(_ source: String) -> Lexer {
        return lexer
    }
}
