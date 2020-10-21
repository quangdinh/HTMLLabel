//
//  ViewController.swift
//  HTMLLabel
//
//  Created by Quang Dinh Le on 10/20/20.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var label: HTMLLabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let html = """
<p>This is a paragraph<br />New line</p>
<strong>Strong text</strong>
<div>
  <h1>New Div Header 1</h1>
  <p>This is another paragraph. With <a href="https://doc.peoplecentrix.dev">Link to docs</a></p>
</div>
<div>
  List items
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
    <li>https://doc.peoplecentrix.dev</li>
  </ul>
</div>
"""
    self.label.setHTMLString(html)
  }
  
  
}

extension ViewController: HTMLLabelDelegate {
  func didTapOnLink(_ link: URL, text: String?) {
    print("Tap on link: \(link)")
  }
}
