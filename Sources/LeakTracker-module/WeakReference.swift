//
//  WeakReference.swift
//  
//
//  Created by Jeremy Bannister on 9/26/23.
//

///
@MainActor
public final class WeakReference<Object: AnyObject> {
    
    ///
    public private(set) weak var object: Object?
    
    ///
    public init(_ object: Object) {
        self.object = object
    }
    
    ///
    public var isReleased: Bool { object == nil }
}
