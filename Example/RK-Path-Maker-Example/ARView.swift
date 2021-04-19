//
//  ARView.swift
//  RK-Path-Maker
//
//  Created by Grant Jarvis on 2/8/21.
//

import ARKit
import FocusEntity
import RealityKit
//import RKPath

class ARSUIView: ARView {
    var dataModel : DataModel
    
    public var focusEntity : FocusEntity!
    
    var pathEntity : RKPathEntity!
    
    var hitPoints = [simd_float3]() {
        didSet {
            self.pathEntity.pathPoints = self.hitPoints
        }
    }
    
    required init(frame frameRect: CGRect, dataModel: DataModel) {
        self.dataModel = dataModel
        super.init(frame: frameRect)
        
        self.session.delegate = self

        //If this device is running iOS 13.4 or later and has LiDAR, then allow occlusion with the LiDAR mesh.
        if #available(iOS 13.4, *),
            ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                runLiDARConfiguration()
        } else{
            runNonLiDARConfig()
        }

        self.pathEntity = RKPathEntity(arView: self,
                                      path: [],
                                      width: 0.35,
                                      materials: [UnlitMaterial.init(color: .blue)])

        self.setupGestures()
        
        do {
          let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
          let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
          self.focusEntity = FocusEntity(
            on: self,
            style: .colored(
              onColor: onColor, offColor: offColor,
              nonTrackingColor: offColor
            )
          )
        } catch {
            self.focusEntity = FocusEntity(on: self, focus: .classic)
          print("Unable to load plane textures")
          print(error.localizedDescription)
        }
    }
    
 
    
    func runNonLiDARConfig(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]

        self.session.run(configuration)
    }
    
    
    //required function.
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
}
