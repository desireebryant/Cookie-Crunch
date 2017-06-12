//
//  Chain.swift
//  CookieCrunch
//
//  Created by Desireé Bryant on 6/5/17.
//  Copyright © 2017 Desireé Bryant. All rights reserved.
//

class Chain: Hashable, CustomStringConvertible {
  var cookies = [Cookie]()
  
  enum ChainType: CustomStringConvertible {
    case horizontal
    case vertical
    
    var description: String {
      switch self {
      case .horizontal:
        return "Horizontal"
      case .vertical:
        return "Vertical"
      }
    }
  } // END OF CHAINTYPE
  
  var chainType: ChainType
  
  var score = 0
  
  init(chainType: ChainType) {
    self.chainType = chainType
  }
  
  func add(cookie: Cookie) {
    cookies.append(cookie)
  }
  
  func firstCookie() -> Cookie {
    return cookies[0]
  }
  
  func lastCookie() -> Cookie {
    return cookies[cookies.count - 1]
  }
  
  var length: Int {
    return cookies.count
  }
  
  var description: String {
    return "type:\(chainType) cookies:\(cookies)"
  }
  
  var hashValue: Int {
    return cookies.reduce(0) {
      $0.hashValue ^ $1.hashValue
    }
  }
  
} // # END OF CHAIN

func ==(lhs: Chain, rhs: Chain) -> Bool {
  return lhs.cookies == rhs.cookies
}

















