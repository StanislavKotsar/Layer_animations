/*
 * Copyright (c) 2014-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

// A tint background color function
func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
    backgroundColorAnimation.fromValue = layer.backgroundColor
    backgroundColorAnimation.toValue = toColor.cgColor
    backgroundColorAnimation.duration = 1
    layer.add(backgroundColorAnimation, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}

// A roundCorners function
func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
    cornerRadiusAnimation.fromValue = layer.cornerRadius
    cornerRadiusAnimation.toValue = toRadius
    cornerRadiusAnimation.duration = 0.33
    layer.add(cornerRadiusAnimation, forKey: nil)
    layer.cornerRadius = toRadius
}

class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    let info = UILabel()
    // MARK: further UI
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        statusPosition = status.center
        
        info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0,  width: view.frame.size.width, height: 30)
        info.backgroundColor = .clear
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .center
        info.textColor = .white
        info.text = "Tap on a field and enter username and password"
        view.insertSubview(info, belowSubview: loginButton)
        
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x +
            view.frame.size.width
        flyLeft.toValue = info.layer.position.x
        flyLeft.duration = 5.0
        info.layer.add(flyLeft, forKey: "infoappear")
        
        let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue = 1.0
        fadeLabelIn.duration = 4.5
        info.layer.add(fadeLabelIn, forKey: "fadein")
        
        username.delegate = self
        password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.delegate = self
        groupAnimation.duration = 0.5
        let flyRight = CABasicAnimation(keyPath: "position.x")
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        flyRight.fromValue = -view.bounds.size.width
        flyRight.toValue = view.bounds.size.width/2
        fadeIn.fromValue = 0.25
        fadeIn.toValue = 1
        groupAnimation.animations = [flyRight, fadeIn]
        groupAnimation.setValue("form", forKey: "name")
        
        groupAnimation.setValue(heading.layer, forKey: "layer")
        heading.layer.add(groupAnimation, forKey: nil)
        
        groupAnimation.setValue(password.layer, forKey: "layer")
        groupAnimation.beginTime = CACurrentMediaTime() + 0.3
        password.layer.add(groupAnimation, forKey: nil)
        
        groupAnimation.setValue(username.layer, forKey: "layer")
        groupAnimation.beginTime = CACurrentMediaTime() + 0.4
        username.layer.add(groupAnimation, forKey: nil)
        
        let cloudAnimation = CABasicAnimation(keyPath: "opacity")
        cloudAnimation.fillMode = .backwards
        cloudAnimation.fromValue = 0
        cloudAnimation.toValue = 1
        cloudAnimation.duration = 0.5
        cloudAnimation.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.add(cloudAnimation, forKey: nil)
        cloudAnimation.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.add(cloudAnimation, forKey: nil)
        cloudAnimation.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.add(cloudAnimation, forKey: nil)
        cloudAnimation.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.add(cloudAnimation, forKey: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.timingFunction = CAMediaTimingFunction(
            name: .easeIn)
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = .backwards
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = .pi / 4.0
        rotate.toValue = 0.0
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        groupAnimation.animations = [scaleDown, rotate, fade]
        loginButton.layer.add(groupAnimation, forKey: nil)
        
        
        animateCloud(layer: cloud1.layer)
        animateCloud(layer: cloud2.layer)
        animateCloud(layer: cloud3.layer)
        animateCloud(layer: cloud4.layer)
    }
    
    func showMessage(index: Int) {
        label.text = messages[index]
        
        UIView.transition(with: status, duration: 0.33,
                          options: [.curveEaseOut, .transitionFlipFromBottom],
                          animations: {
                            self.status.isHidden = false
        },
                          completion: {_ in
                            //transition completion
                            delay(seconds: 2.0) {
                                if index < self.messages.count-1 {
                                    self.removeMessage(index: index)
                                } else {
                                    //reset form
                                    self.resetForm()
                                }
                            }
        }
        )
    }
    
    func removeMessage(index: Int) {
        
        UIView.animate(withDuration: 0.33, delay: 0.0,
                       animations: {
                        self.status.center.x += self.view.frame.size.width
        },
                       completion: {_ in
                        self.status.isHidden = true
                        self.status.center = self.statusPosition
                        
                        self.showMessage(index: index+1)
        }
        )
    }
    
    func resetForm() {
        UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop,
                          animations: {
                            self.status.isHidden = true
                            self.status.center = self.statusPosition
        },
                          completion: nil
        )
        
        UIView.animate(withDuration: 0.2, delay: 0.0,
                       animations: {
                        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
                        self.spinner.alpha = 0.0
                        self.loginButton.bounds.size.width -= 80.0
                        self.loginButton.center.y -= 60.0
        },
                       completion: {_ in
                        let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
                        tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
                        roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
        })
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.bounds.size.width += 80.0
        },
                       completion: {_ in
                        self.showMessage(index: 0)
        }
        )
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.center.y += 60.0
                        self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
                        self.spinner.alpha = 1.0
        },
                       completion: nil
        )
        
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
        roundCorners(layer: loginButton.layer, toRadius: 25.0)
    }
    
    func animateCloud(layer: CALayer) {
        
        //1
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: TimeInterval = Double(
            view.layer.frame.size.width - layer.frame.origin.x)
            * cloudSpeed
        
        //2
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.width +
            layer.bounds.width/2
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        layer.add(cloudMove, forKey: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
    
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation,
                          finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        
        if name == "form" {
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.damping = 7.5
            pulse.fromValue = 1.25
            pulse.toValue = 1.0
            pulse.duration = pulse.settlingDuration
            layer?.add(pulse, forKey: nil)
        }
        
        if name == "cloud" {
            guard let layer = anim.value(forKey: "layer") as? CALayer else { return }
            layer.position.x = -layer.bounds.width/2
            delay(seconds: 0.5) {
                self.animateCloud(layer: layer)
            }
        }
        
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let runningAnimations = info.layer.animationKeys() else {
            return
        }
        info.layer.removeAnimation(forKey: "infoappear")
    }
}
