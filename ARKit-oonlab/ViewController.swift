//
//  ViewController.swift
//  ARKit-oonlab
//
//  Created by Rizky Ariestiyansyah on 15/07/18.
//  Copyright © 2018 Rizky Ariestiyansyah. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let jetscene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Jet system
        let jet = jetscene.rootNode.childNode(withName: "ship", recursively: true)
        jet!.name = "ship"
        
        // particle system
        let particleSystem = SCNParticleSystem(named: "asap.scnp", inDirectory: nil)
        let particleNode = SCNNode()
        particleNode.addParticleSystem(particleSystem!)
        
        // add particle to ship
        jet!.addChildNode(particleNode)
        particleNode.position = SCNVector3Make(0, 0, -1)
        jet!.position = SCNVector3Make(0, 0.5, -0.8)
        jet!.eulerAngles = SCNVector3Make(-70, 135, 0)
        
        // Set the scene to the view
        let scene = SCNScene()
        scene.rootNode.addChildNode(jet!)
        
        sceneView.scene = scene
        self.registerTapGesture()
    }
    
    func registerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(tappedOnScene(sender:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedOnScene(sender: UITapGestureRecognizer){
        guard let shipNode = self.sceneView.scene.rootNode.childNode(withName: "ship",
            recursively: true) else {
            return
        }
        
        shipNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic, shape: nil)
        shipNode.physicsBody?.isAffectedByGravity = false
        shipNode.physicsBody?.damping = 0.0
        shipNode.physicsBody?.applyForce(SCNVector3Make(0, 50, -50), asImpulse: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
