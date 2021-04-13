//
//  ViewController.swift
//  CUBEATTACK
//
//  Created by Özgün Yildiz on 13.04.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var minHeight: CGFloat = 0.2
    var maxHeight: CGFloat = 0.6
    var minDispersal: CGFloat = -4
    var maxDispersal: CGFloat = 4
    
    // In order to place our nodes in a position, we need SCNVector3, which returns 3 position variables. In our case, we want CGFloats since we declared our variables as floats. As you can see, there are three CGFloats, which are all random. The first one denotes the x value of SCNVector, the second y and the third z. You can visiualize these values on a coordinate plane, where x is to the right of you, y to the left and z behind you.
    func generateRandomVector() -> SCNVector3 {
        return SCNVector3(CGFloat.random(in: minDispersal...maxDispersal),
                          CGFloat.random(in: minDispersal...maxDispersal),
                          CGFloat.random(in: minDispersal...maxDispersal))
    }
    // You can build any other color with red, green and blue. With this, we are assigning completely random colors to the cubes. Be aware that this instantiation of UIColor takes only floats for the respective colors. Meaning, red with a value of 0.1 might be bright red, while a red with a value of 0.7 might be wine red.
    func generateRandomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: CGFloat.random(in: 0.5...1))
    }
    
    
    // setting the size to random with variables we have created above
    func generateRandomSize() -> CGFloat {
        return CGFloat.random(in: minHeight...maxHeight)
    }
    
    
    func generateCube() {
        // remember, generateRandomSize returns a random float from 0.2-0.6. So we assign the output of the random float to s. For clarity's sake:
        // If you are asking yourself, why s doesn't have a function type but rather is a float, please notice the braces at the end of the function. If we excluded them, s would be of type function and not float and we wouldn't be able to pass it in to SCNBox (which we'll do in the next step). So, the braces actually create an instance of the function, and whatever is assigned to it receives the return of the function (and void if there is none).
        let s = generateRandomSize()
        
        // here we are creating our cube with the random sizes. ChamferRadius specifies the roundness of the corners (for comparison: try a chamferRadius of 0.3 and with 0.03 and notice the difference)
        let cube = SCNBox(width: s, height: s, length: s, chamferRadius: 0.03)
//        let material = SCNMaterial()
//        material.diffuse.contents = generateRandomColor()
//        cube.materials = [material]
        
        // if our material has just one material property, we can use this
        
        cube.materials.first?.diffuse.contents = generateRandomColor()
        
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.position = generateRandomVector()
        let rotateAction = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 3)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        cubeNode.runAction(repeatAction)
        
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    @IBAction func addCubeClicked(_ sender: Any) {
        generateCube()
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
    

    

}
