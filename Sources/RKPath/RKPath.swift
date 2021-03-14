//
//  RKPathEntity.swift
//  SCNPath+Example
//
//  Created by Grant Jarvis on 3/13/21.
//  Copyright © 2021 Max Cobb. All rights reserved.
//

import SceneKit
import Combine
import RealityKit

public class RKPathEntity : Entity {
    
    public var pathPoints = [simd_float3]() {
        didSet {
            self.recalcGeometry()
        }
    }
   
    private var pathMaterials : [Material]?
    
    private var pathEntitiesInScene = [Entity]()
    
    private var pathWidth : Float = 0.5
    
    init(
        path: [simd_float3],
        width: Float = 0.5,
        materials: [Material] = []
    ) {
        super.init()
        self.pathPoints = path
        self.pathWidth = width
        self.pathMaterials = materials
        //Remove synchronization to save memory.
        self.visit(using: {$0.synchronization = nil})
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    

    

    
    func makePathSegment(length: Float, width: Float = 0.35) -> Entity {
        let pivotPoint = Entity()
        let rectangleMesh = MeshResource.generatePlane(width: width, depth: length + width, cornerRadius: width / 2)
        let generatedRectangle = ModelEntity(mesh: rectangleMesh,
                                             materials: pathMaterials ?? [UnlitMaterial.init(color: .blue)])
        pivotPoint.addChild(generatedRectangle)
        
        //This shape can be broken down into 3 parts: 1 rectangle of length length, and 2 ends that are half-circles of radius pathWidth / 2.
        //Put the center of the half-circle at one end of the rectangle at the center of the pivot point; We want each path to overlap on the half-circle tips.
        let zPosition = (-(length + width) / 2) + (width / 2)
        
        
        generatedRectangle.position = [0,0,zPosition]
        return pivotPoint
    }
    
    
    func recalcGeometry() {
        
        //Start off with just a circle for the first position.
        if self.pathPoints.count == 1 {
            let pathSegment = makePathSegment(length: 0)
            let newPosition = pathPoints[0]
            self.addChild(pathSegment)
            pathEntitiesInScene.append(pathSegment)
            pathSegment.position = newPosition
            return
        }
        //Using a smaller distance between points on a curve will lead to smoother curves.
        
        //Keep all y-values the same so that the ends don't protrude in the y-dimension (looks more like disjointed shapes than one continouous path).
        let currentIndex = (pathPoints.count - 1)
        let lastPosition : SIMD3<Float> = [pathPoints[currentIndex - 1].x,
                                           pathPoints[0].y,
                                           pathPoints[currentIndex - 1].z]
        let newPosition : SIMD3<Float> = [pathPoints[currentIndex].x,
                                          lastPosition.y,
                                          pathPoints[currentIndex].z]
        let length = simd_length(newPosition - lastPosition)
        let pathSegment = makePathSegment(length: length)
        self.addChild(pathSegment)
        pathEntitiesInScene.append(pathSegment)
        pathSegment.position = lastPosition
        
        //Rotate the rectangle to connect the dots.
        // --(lastPosition is already at one end of the rectangle, rotate to put newPosition at the other end).
        pathSegment.look(at: newPosition, from: lastPosition, relativeTo: nil)
    }
}




extension Entity {
    ///From Reality Composer, the visible ModelEntities are children of nonVisible Entities
    ///Recursively searches through all descendants for a ModelEntity, Not just through the direct children.
    ///Reutrns the first model entity it finds.
    ///Returns the input entity if it is a model entity.
    func findHasModel() -> HasModel? {
        if self is HasModel { return self as? HasModel }
        
        guard let hasModels = self.children.filter({$0 is HasModel}) as? [HasModel] else {return nil}
        
        if !(hasModels.isEmpty) { //it's Not empty. We found at least one modelEntity.
            
            return hasModels[0]
            
        } else { //it is empty. We did Not find a modelEntity.
            //every time we check a child, we also iterate through its children if our result is still nil.
            for child in self.children{
                
                if let result = child.findHasModel(){
                    return result
                }}}
        return nil //default
    }
    
    func visit(using block: (Entity) -> Void) {
        block(self)

        for child in children {
            child.visit(using: block)
        }
    }
}
