//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var arr = [Array<Int>()]
var arr0 = [Int]()

var arr2: [Int] = [1,2,3]
var arr3: [Int] = [4,5,6]

arr0.append(3)

arr.insert(arr3, at: 0)

var imageURL: Int?
if let url = imageURL {
    
}
//------------------------------------------------------------------------------
var myString:NSString = "I AM KIRIT MODI"
var myMutableString = NSMutableAttributedString()
myMutableString = NSMutableAttributedString(string: myString as String , attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])

myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:2,length:2))
lbl_First.attributedText = myMutableString

override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1
    let string = "Testing Attributed Strings" as NSString
    var attributedString = NSMutableAttributedString(string: string)
    
    // 2
    let firstAttributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.yellowColor(), NSUnderlineStyleAttributeName: 1]
    let secondAttributes = [NSForegroundColorAttributeName: UIColor.redColor(), NSBackgroundColorAttributeName: UIColor.blueColor(), NSStrikethroughStyleAttributeName: 1]
    let thirdAttributes = [NSForegroundColorAttributeName: UIColor.greenColor(), NSBackgroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(40)]
    
    // 3
    attributedString.addAttributes(firstAttributes, range: string.rangeOfString("Testing"))
    attributedString.addAttributes(secondAttributes, range: string.rangeOfString("Attributed"))
    attributedString.addAttributes(thirdAttributes, range: string.rangeOfString("Strings"))
    
    // 4
    attributedLabel.attributedText = attributedString
}