//
//  Array2D.swift
//  CookieCrunch
//
//  Created by Desireé Bryant on 5/26/17.
//  Copyright © 2017 Desireé Bryant. All rights reserved.
//

struct Array2D<T> {
  let columns: Int
  let rows: Int
  
  fileprivate var array: Array<T?>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(repeating: nil, count: rows * columns)
  }
  
  subscript(column: Int, row: Int) -> T? {
    get {
      return array[row * columns + column]
    }
    set {
      array[row * columns + column] = newValue
    }
  }
} // # END OF ARRAY2D<T>
