//
//  LeakTracker.swift
//  
//
//  Created by Jeremy Bannister on 9/26/23.
//

///
public struct LeakTracker {
    
    ///
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    @TaskLocal
    public static var current: LeakTracker = .no_tracking
    
    ///
    private let _trackObject: @MainActor (String?, any AnyObject)->()
    
    ///
    public init(
        trackObject: @escaping @MainActor (String?, any AnyObject)->Void
    ) {
        
        ///
        self._trackObject = trackObject
    }
    
    ///
    @MainActor
    public func track(_ object: any AnyObject) {
        _trackObject(nil, object)
    }
    
    ///
    @MainActor
    public func track(_ object: any AnyObject, name: String) {
        _trackObject(name, object)
    }
    
    ///
    public subscript(_ subTrackerName: String) -> Self {
        self.subTracker(named: subTrackerName)
    }
    
    ///
    public func subTracker(named subTrackerName: String) -> Self {
        .init(
            trackObject: { name, object in
                _trackObject(
                    name.map { "\(subTrackerName).\($0)" } ?? subTrackerName,
                    object
                )
            }
        )
    }
    
    ///
    public static var no_tracking: Self {
        .init(trackObject: { _, _ in })
    }
}
