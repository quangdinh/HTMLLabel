//
//  HTMLLabel.swift
//  HTMLLabel
//
//  Created by Quang Dinh Le on 10/20/20.
//

import UIKit

@objc protocol HTMLLabelDelegate {
  func didTapOnLink(_ link: URL, text: String?) -> Void
}

class HTMLLabel: UILabel {
  @IBOutlet weak var delegate: HTMLLabelDelegate?
  
  
  let layoutManager = NSLayoutManager()
  let textContainer = NSTextContainer(size: CGSize.zero)
  var textStorage = NSTextStorage() {
    didSet {
      textStorage.addLayoutManager(layoutManager)
    }
  }
  
  override var attributedText: NSAttributedString? {
    didSet {
      if let attributedText = attributedText {
        textStorage = NSTextStorage(attributedString: attributedText)
      } else {
        textStorage = NSTextStorage()
      }
    }
  }
  
  override var lineBreakMode: NSLineBreakMode {
    didSet {
      textContainer.lineBreakMode = lineBreakMode
    }
  }
  
  override var numberOfLines: Int {
    didSet {
      textContainer.maximumNumberOfLines = numberOfLines
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUp()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  fileprivate func setUp() {
    self.isUserInteractionEnabled = true
    self.lineBreakMode = .byTruncatingTail
    layoutManager.addTextContainer(textContainer)
    textContainer.lineFragmentPadding = 0
    textContainer.lineBreakMode = lineBreakMode
    textContainer.maximumNumberOfLines = 0
    textContainer.size = bounds.size
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(HTMLLabel.labelTapped(_:)))
    self.addGestureRecognizer(tapGesture)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    textContainer.size = bounds.size
  }
  
  public func setHTMLString(_ html: String) {
    let data = Data(html.utf8)
    guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return }
    self.numberOfLines = 0
    self.attributedText = attributedString
  }
  
  @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
    guard gesture.state == .ended else {
      return
    }
    
    let locationOfTouch = gesture.location(in: gesture.view)
    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouch.x,
                                                 y: locationOfTouch.y)
    
    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                        in: textContainer,
                                                        fractionOfDistanceBetweenInsertionPoints: nil)
    if let link = self.attributedText?.attribute(NSAttributedString.Key.link, at: indexOfCharacter, effectiveRange: nil) as? URL,
       let delegate = self.delegate {
      delegate.didTapOnLink(link, text: nil)
    }
    
  }
  
}
