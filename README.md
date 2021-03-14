# RKPath

This package makes it easy to generate paths in RealityKit.
There is an example project included in this repo to show you how to use it.
After you add the swift package and import RKPath,

1. Initialize a new path entity like this:
 ``` swift
      var pathEntity = RKPathEntity(path: [])
```
or like this:
 ``` swift
      var pathEntity = RKPathEntity(path: [],
                                  width: 0.35,
                                  materials: [UnlitMaterial.init(color: .blue)])
```

2. Add your path entity to an anchor that is anchored in the scene like this;
``` swift
        let worldAnchor = AnchorEntity() //point 0,0,0
        self.scene.addAnchor(worldAnchor)
        worldAnchor.addChild(pathEntity)
```

3. Add points to your path and it will automatically update:
``` swift
        let myNewPoint = SIMD3<Float>()
        self.pathEntity.pathPoints.append(myNewPoint)
```
