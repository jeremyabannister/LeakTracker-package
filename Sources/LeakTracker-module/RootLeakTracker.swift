//
//  RootLeakTracker.swift
//  
//
//  Created by Jeremy Bannister on 9/26/23.
//

///
public final class RootLeakTracker {
    
    ///
    public let name: String?
    private let shouldTrackForReal: Bool
    
    ///
    @MainActor
    private var trackedObjects: [(name: String?, weakReference: WeakReference<any AnyObject>)] = []
    
    ///
    public init(
        name: String? = nil,
        shouldTrackForReal: Bool = true
    ) {
        self.name = name
        self.shouldTrackForReal = shouldTrackForReal
    }
    
    ///
    @MainActor
    public func unreleasedObjects() -> [(name: String?, object: any AnyObject)] {
        
        ///
        var unreleasedObjects: [(String?, any AnyObject)] = []
        
        ///
        for i in trackedObjects.indices.reversed() {
            
            ///
            let (objectName, weakReference) = trackedObjects[i]
            
            ///
            if let object = weakReference.object {
                unreleasedObjects.append((objectName, object))
            } else {
                trackedObjects.remove(at: i)
            }
        }
        
        ///
        return unreleasedObjects.reversed()
    }
    
    ///
    public var asLeakTracker: LeakTracker {
        .init(
            trackObject: { objectName, object in
                self.track(
                    object,
                    name: objectName.map { objectName in
                        self.name.map { parentName in
                            "\(parentName).\(objectName)"
                        } ?? objectName
                    } ?? self.name
                )
            }
        )
    }
    
    ///
    @MainActor
    public func track(
        _ object: some AnyObject,
        name: String? = nil
    ) {
        
        ///
        guard shouldTrackForReal else { return }
        
        ///
        trackedObjects.append((name, .init(object)))
    }
    
    ///
    @MainActor
    public func assertNoLeaks() throws {
        try assertMaximumLeakCount(0)
    }
    
    ///
    @MainActor
    public func assertMaximumLeakCount(
        _ maximumLeakCount: Int
    ) throws {
        
        ///
        let leakCount = self.unreleasedObjects().count
        
        ///
        if leakCount > maximumLeakCount {
            
            ///
            throw LeakCount(leakCount: leakCount)
        }
    }
    
    ///
    public struct LeakCount: Error {
        public let leakCount: Int
    }
}
