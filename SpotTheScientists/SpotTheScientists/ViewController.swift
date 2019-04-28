//
//  ViewController.swift
//  SpotTheScientists
//
//  Created by Owen Henley on 28/04/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Properties
    private var scientists = [String: Scientist]()

    // MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!

    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Scientists", bundle: nil) else {
            fatalError("Couldn't load tracking images.")
        }

        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        configuration.trackingImages = trackingImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - Methods
    /// Load the JSON data.
    ///
    /// Get, and decode the data from scientists.json.
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "scientists", withExtension: ".json") else {
            fatalError("Failed to find JSON in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load JSON data.")
        }

        let decoder = JSONDecoder()

        guard let loadedScientests = try? decoder.decode([String: Scientist].self, from: data) else {
            fatalError("Failed to parse JSON.")
        }

        scientists = loadedScientests
    }

    /// Make a node for text.
    ///
    /// - Parameters:
    ///   - str: Input text.
    ///   - font: Preffered font.
    ///   - maxWidth: Max width value.
    /// - Returns: A new text node.
    private func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        text.flatness = 0.1
        text.font = font

        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }

        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)

        return textNode
    }
}
// MARK: - ARSCNViewDelegate
extension ViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }

        guard let name = imageAnchor.referenceImage.name else {
            return nil
        }

        guard let scientist = scientists[name] else {
            return nil
        }

        // make a plane
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear

        // follow plane
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2

        // make a node
        let node = SCNNode()
        node.addChildNode(planeNode)

        let spacing: Float = 0.005

        let nameNode = textNode(scientist.name, font: UIFont.boldSystemFont(ofSize: 10))
        nameNode.pivotOnTopLeft()
        nameNode.position.x += Float(plane.width / 2) + spacing
        nameNode.position.y += Float(plane.height / 2)

        planeNode.addChildNode(nameNode)

        let bioNode = textNode(scientist.bio, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
        bioNode.pivotOnTopLeft()
        bioNode.position.x += Float(plane.width / 2) + spacing
        nameNode.position.y = nameNode.position.y - nameNode.height - spacing
        planeNode.addChildNode(bioNode)

        let flag = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width / 8 * 5)
        flag.firstMaterial?.diffuse.contents = UIImage(named: scientist.country)

        let flagNode = SCNNode(geometry: flag)
        flagNode.pivotOnTopCenter()
        flagNode.position.y -= Float(plane.height / 2) + spacing
        planeNode.addChildNode(flagNode)

        return node
    }
}

// Useful Extension snippet
extension SCNNode {
    var width: Float {
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }

    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }

    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }

    func pivotOnTopCenter() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
}
