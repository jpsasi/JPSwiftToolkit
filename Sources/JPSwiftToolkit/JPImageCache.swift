//
//  File.swift
//  JPSwiftToolkit
//
//  Created by Sasikumar JP on 7/29/24.
//

import UIKit

@MainActor
public class JPImageCache {
  public static let imageCache = JPCache<URL, Data>()
  
  public init() { }
  
  public func loadImage(from url: URL) async -> UIImage? {
    if let imageData = JPImageCache.imageCache.value(forKey: url),
       let image = UIImage(data: imageData) {
      return image
    }
    
    do {
      let (imageData, response) = try await URLSession.shared.data(from: url)
      if let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 {
        JPImageCache.imageCache.insert(imageData, forKey: url)
        return UIImage(data: imageData) ?? nil
      } else {
        return nil
      }
    } catch {
      return nil
    }
  }
}
