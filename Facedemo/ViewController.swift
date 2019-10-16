//
//  ViewController.swift
//  Facedemo
//
//  Created by MyMAC on 13/09/19.
//  Copyright © 2019 Unikwork. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
class ViewController: UIViewController,ARSCNViewDelegate{

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var scanView: ARSCNView!
    var facePoseResult = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking not available on this on this device model!")
            
        }
        let configuration = ARFaceTrackingConfiguration()
        scanView.delegate = self
        scanView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: scanView.device!)!
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            facePoseAnalyzer(anchor: faceAnchor)
            DispatchQueue.main.async {
                self.lbl.text = self.facePoseResult
            }
        }
    }
    func facePoseAnalyzer(anchor: ARFaceAnchor) {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let innerUp = anchor.blendShapes[.browInnerUp]
        let tongue = anchor.blendShapes[.tongueOut]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        let eyeBlinkLeft = anchor.blendShapes[.eyeBlinkLeft]
        let jawOpen = anchor.blendShapes[.jawOpen]
        
        var newFacePoseResult = ""
        if ((jawOpen?.decimalValue ?? 0.0) + (innerUp?.decimalValue ?? 0.0)) > 0.6 {
            newFacePoseResult = "😧"
        }
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            newFacePoseResult = "😀"
        }
        if innerUp?.decimalValue ?? 0.0 > 0.8 {
            newFacePoseResult = "😳"
        }
        if tongue?.decimalValue ?? 0.0 > 0.08 {
            newFacePoseResult = "😛"
        }
        if cheekPuff?.decimalValue ?? 0.0 > 0.5 {
            newFacePoseResult = "🤢"
        }
        if eyeBlinkLeft?.decimalValue ?? 0.0 > 0.5 {
            newFacePoseResult = "😉"
        }
        if self.facePoseResult != newFacePoseResult {
            self.facePoseResult = newFacePoseResult
        }
        
    }
    
}

