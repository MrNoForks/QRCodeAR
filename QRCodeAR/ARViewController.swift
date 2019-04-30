//
//  ARViewController.swift
//  QRCodeAR
//
//  Created by Boppo on 30/04/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController,ARSCNViewDelegate {

    private var virtualObjectNode = ModelLoader()
    
    var modelName : String?
    
    private var sceneView : ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = ARSCNView()
        
        sceneView.showsStatistics = true
        
        //sceneView.frame = view.frame
        
      //  view.addSubview(sceneView)
        
        view = sceneView
        
        virtualObjectNode.loadModel(modelName: modelName ?? "", positionX: 0, positionY: 0, positionZ: -0.7, modelSize: 0.05, appearanceAnimation: true, withDuration: 2)
        
        sceneView.scene.rootNode.addChildNode(virtualObjectNode)
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = renderer.pointOfView else {return}
        // pointOfView.worldFront
        
        
        
        let transform = pointOfView.simdTransform
        let myPosInWorldSpace = simd_make_float4(0,0,-2,1)
        let myPosInCamSpace = simd_mul(transform,myPosInWorldSpace)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        virtualObjectNode.position = SCNVector3(x: myPosInCamSpace.x, y: myPosInCamSpace.y, z: myPosInCamSpace.z)
        SCNTransaction.commit()
        
        //        let isVisible = renderer.isNode(virtualObjectNode, insideFrustumOf: pointOfView)
        //        if !isVisible{
        //            guard let pointOfView = sceneView.pointOfView else { return}
        //
        //            let transform = pointOfView.simdTransform
        //            let myPosInWorldSpace = simd_make_float4(0,0,-2,1)
        //            let myPosInCamSpace = simd_mul(transform,myPosInWorldSpace)
        //
        //            SCNTransaction.begin()
        //            SCNTransaction.animationDuration = 0.9
        //            virtualObjectNode.position = SCNVector3(x: myPosInCamSpace.x, y: myPosInCamSpace.y, z: myPosInCamSpace.z)
        //            SCNTransaction.commit()
        //        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
