//
//  JPCache.swift
//
//
//  Created by Sasikumar JP on 6/15/24.
//

import Foundation

/*
 * This class cache the information. Key and value could be any data
 * type. It can accept reference type and value type as a key and value
 * NSCache accepts only the NSObjects as a key. so it creates a wrapper for
 * key. so it can accept any type as a key.
 */
public class JPCache<Key: Hashable, Value> {
  private let wrapped: NSCache<WrappedKey, Entry> = NSCache()
  
  public func insert(_ value: Value, forKey key: Key) {
    let entry = Entry(value: value)
    wrapped.setObject(entry, forKey: WrappedKey(key: key))
  }
  
  public func value(forKey key: Key) -> Value? {
    guard let entry = wrapped.object(forKey: WrappedKey(key: key)) else {
      return nil
    }
    return entry.value
  }
  
  public func removeValue(forKey key: Key) {
    wrapped.removeObject(forKey: WrappedKey(key: key))
  }
}


public extension JPCache {
  
  final class WrappedKey: NSObject {
    let key: Key
    
    public init(key: Key) {
      self.key = key
    }
    
    public override var hash: Int {
      return key.hashValue
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else {
        return false
      }
      return value.key == key
    }
  }
}

public extension JPCache {
  final class Entry {
    let value: Value
    
    public init(value: Value) {
      self.value = value
    }
  }
}
