//
//  BouncyBallView.swift
//  BouncyBallView
//
//  Created by Joshua Bury on 3/18/19.
//  Copyright © 2019 Joshua Bury. All rights reserved.
//

import UIKit

class BouncyBallView: UIView {
	
	let backColor  = UIColor(white: 0.1, alpha: 1.0)
	let ballColor  = UIColor.yellow
	let ballRadius = CGFloat(0.05)
	let ballSpeed  = CGFloat(0.03)
	
	var px  = CGFloat()
	var py  = CGFloat()
	var vx  = CGFloat()
	var vy  = CGFloat()
	var rad = CGFloat()
	
	var ballTimer = Timer()
	
	lazy var doubleTap: UITapGestureRecognizer = {
	
		let temp = UITapGestureRecognizer(target: self,
										  action: #selector(BouncyBallView.handleTap(_:)))
		
		temp.numberOfTapsRequired = 2
		
		return temp
		
	}()
	
	let impactGenerator = UIImpactFeedbackGenerator()
	
	// MARK: - Setup and Initialization -
	
	private func setup() {
		
		self.isOpaque = true
		self.clearsContextBeforeDrawing = true
		
		ballTimer = Timer.scheduledTimer(timeInterval: 1/60,
										 target: self,
										 selector: #selector(doBallMotion),
										 userInfo: nil,
										 repeats: true)
		
		addGestureRecognizer(doubleTap)
	}
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		setup()
		launchBall()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
	
		super.init(coder: aDecoder)
		
		setup()
		launchBall()
		
	}
	
	// MARK: - Ball Dynamics -
	
	private func launchBall(x: CGFloat = 0.5, y: CGFloat = 0.5) {
	
		px = x
		py = y
		
		let dir = CGFloat.random(in: 0 ..< 2 * .pi)
		
		vx = ballSpeed * cos(dir)
		vy = ballSpeed * sin(dir)
		
		rad = ballRadius
		
		setNeedsDisplay()
		
	}
	
	@objc func doBallMotion() {
	
		px += vx
		py += vy
		
		let minPos = rad
		let maxPos = 1 - rad
		
		var hitWall = false
		
		if (px < minPos) {
			px = minPos
			vx = -vx
			hitWall = true
		}
		
		if (px > maxPos) {
			px = maxPos
			vx = -vx
			hitWall = true
		}
		
		if (py < minPos) {
			py = minPos
			vy = -vy
			hitWall = true
		}
		
		if (py > maxPos) {
			py = maxPos
			vy = -vy
			hitWall = true
		}
	
		setNeedsDisplay ()
		
		if (hitWall) {
			impactGenerator.impactOccurred()
		}
		
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
	
		if (sender.state == .ended) {
		
			let pos = sender.location(in: self)
			
			let x = pos.x / frame.width
			let y = pos.y / frame.height
			
			launchBall(x: x, y: y)
			
		}
		
	}
	
	// MARK: - Drawing -
	
	private func ballScreenRect() -> CGRect {
	
		let x = px * frame.width
		let y = py * frame.height
		
		var r = rad * frame.width
		
		if (frame.width > frame.height) {
			r = rad * frame.height
		}
		
		return CGRect(x: x - r , y: y - r, width: 2 * r, height: 2 * r)
		
	}
	
	override func draw(_ rect: CGRect) {
		
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.setFillColor(backColor.cgColor)
		context.fill(rect)
		
		context.setFillColor(ballColor.cgColor)
		context.fillEllipse(in: ballScreenRect())
		
	}
	
}
