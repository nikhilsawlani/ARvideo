//
//  ViewController.swift
//  ARKit Sample
//
//  Created by Roberto Perez Cubero on 26/09/2017.
//  Copyright © 2017 tokbox. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import OpenTok

// Please Fill your OpenTok session data
let kApiKey = "46187812"
let kToken = "T1==cGFydG5lcl9pZD00NjE4NzgxMiZzaWc9Y2VhODNkMzliOWZhOTc1MjA5YTI0ZmNkYWFkMjdhZTAyNDRhNmMzNjpzZXNzaW9uX2lkPTFfTVg0ME5qRTROemd4TW41LU1UVXpOamt5TURFeE5EWTNOWDR4ZVRJNWNFdzNSV05CUVVwQ1NtdGtlRnBUVG1KMFprOS1mZyZjcmVhdGVfdGltZT0xNTM3MDgzMzE5JnJvbGU9bW9kZXJhdG9yJm5vbmNlPTE1MzcwODMzMTkuNjI1ODcyNjk4OTM4Mg=="
let kSessionId = "1_MX40NjE4NzgxMn5-MTUzNjkyMDExNDY3NX4xeTI5cEw3RWNBQUpCSmtkeFpTTmJ0Zk9-fg"

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var session : OTSession?
    let sessionDelegate = SessionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/opentok.scn")!
        let frame = scene.rootNode.childNode(withName: "frame", recursively: false)!
       // let model = scene.rootNode.childNode(withName: "missile", recursively: true)!
        
        //let scene1 = SCNScene(named: "art.scnassets/missile.scn")!
        //let frame1 = scene1.rootNode.childNode(withName: "missile", recursively: true)!
        
        //frame1.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 2, y: 0, z: 0, duration: 3)))
        
        // Set the scene to the view
       // sceneView.scene = scene1
        
        let node = frame.childNode(withName: "plane", recursively: false)!
        frame.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 3)))
        sceneView.scene = scene
        
        sessionDelegate.node = node
        
        // Connect to OpenTok Session
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: sessionDelegate)
        session?.connect(withToken: kToken, error: nil)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
}

class SessionDelegate: NSObject, OTSessionDelegate {
    var node: SCNNode?
    
    func sessionDidConnect(_ session: OTSession) {
        print("OpenTok Session Connect")
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        guard let sub = OTSubscriber(stream: stream, delegate: nil),
            let targetNode = node
            else {
                print("Error creating subscriber")
                return
        }
        sub.videoRender = OpenTokMetalVideoRender(targetNode)
        session.subscribe(sub, error: nil)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("Error connecting to the session: \(error)")
    }
}

