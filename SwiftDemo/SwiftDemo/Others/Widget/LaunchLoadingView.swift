//
//  LaunchLoadingView.swift
//  SwiftDemo
//
//  Created by ltz on 2025/8/20.
//

import UIKit

class LaunchLoadingView: UIView {
    
    // MARK: - UI Properties
    private var timerLabel: UILabel!
    private var timer: DispatchSourceTimer?
    private var seconds: Int = 0
    private var timerQueue: DispatchQueue!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // 创建专用的串行队列用于计时器
        timerQueue = DispatchQueue(label: "com.launchloadingview.timer", qos: .default)
        
        // 设置背景色为白色
        backgroundColor = UIColor.white
        
        // 创建并设置logo ImageView
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 将ImageView添加到自定义视图上
        addSubview(imageView)
        
        // 创建计时器标签
        timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.black
        timerLabel.font = UIFont.systemFont(ofSize: 16)
        timerLabel.text = ""
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerLabel)
        
        // 居中约束
        let centerXConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        // 计时器标签约束
        let labelCenterXConstraint = NSLayoutConstraint(item: timerLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let labelTopConstraint = NSLayoutConstraint(item: timerLabel!, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 20) // logo下方20点
        
        // 激活约束
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint, labelCenterXConstraint, labelTopConstraint])
    }
    
    // MARK: - Public Methods
    func show() {
        ATDemoLog("%@ aaaaa", UIApplication.shared.currentKeyWindow!)
        guard let window = UIApplication.shared.currentKeyWindow else { return }
        
        frame = window.bounds // 确保填满整个屏幕
        window.addSubview(self)
    }
    
    func startTimer() {
        // 先停止之前的计时器
        stopTimer()
        
        // 重置计时器
        seconds = 0
        
        // 在主线程更新UI
        DispatchQueue.main.async {
            self.timerLabel.text = "\(kLocalizeStr("Current")) 00:00 ,\(kLocalizeStr("timeout setting")):\(FirstAppOpen_Timeout)"
        }
        
        // 创建高精度计时器
        timer = DispatchSource.makeTimerSource(queue: timerQueue)
        
        if let timer = timer {
            // 设置计时器：立即开始，每1秒触发一次，允许0.1秒的误差
            timer.schedule(deadline: .now() + 1.0, repeating: 1.0, leeway: .milliseconds(100))
            
            // 设置计时器事件处理
            timer.setEventHandler { [weak self] in
                self?.updateTimer()
            }
            
            // 启动计时器
            timer.resume()
        }
    }
    
    func dismiss() {
        // 停止计时器
        stopTimer()
        
        removeFromSuperview() // 从父视图中移除
    }
    
    // MARK: - Private Methods
    private func updateTimer() {
        seconds += 1
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        // 确保UI更新在主线程执行
        DispatchQueue.main.async {
            self.timerLabel.text = "\(kLocalizeStr("Current")) \(String(format: "%02d:%02d", minutes, remainingSeconds)) ,\(kLocalizeStr("timeout setting")):\(FirstAppOpen_Timeout)"
        }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        // 确保在对象销毁时停止计时器
        stopTimer()
    }
}
