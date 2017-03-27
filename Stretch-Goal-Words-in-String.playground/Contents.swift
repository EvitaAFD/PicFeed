//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func numWordsString(_ str: String) -> Int {
    return str.components(separatedBy: " ").count
}

numWordsString(str)
numWordsString("I love dogs, they are like so great, yay dogs")
