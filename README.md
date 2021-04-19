# RKPath

This package makes it easy to generate paths in RealityKit.
There is an example project included in this repo to show you how to use it.
After you add the swift package and `import RKPath`,

1. Initialize a new path entity like this:
 ``` swift
      var pathEntity = RKPathEntity(arView: arView,
                                    path: [])
```
or like this:
 ``` swift
      var pathEntity = RKPathEntity(arView: arView,
                                      path: [],
                                      width: 0.35,
                                      materials: [UnlitMaterial.init(color: .blue)])
```
Your entity will automatically add itself to the scene.

3. Add points to your path (or change the pathPoints array however you want) and it will automatically update:
``` swift
        let myNewPoint = SIMD3<Float>()
        self.pathEntity.pathPoints.append(myNewPoint)
```
