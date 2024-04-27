//
//  UIView+ChainableAnimations.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 12/12/23.
//

import Foundation
import UIKit
import CoreData

public extension UIView {
    /// Perform multiple animation one after another with chaining style
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    ///   - dampingRatio: The damping ratio for the spring animation as it approaches its quiescent state.
    ///   To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
    ///   - velocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    ///   A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
    ///   - options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIView.AnimationOptions.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be nil.
    /// - Returns: AnimationChain
    static func chainAnimate(
        withDuration duration: TimeInterval,
        delay: TimeInterval = 0,
        usingSpringWithDamping dampingRatio: CGFloat = 1,
        initialSpringVelocity velocity: CGFloat = 1,
        options: UIView.AnimationOptions = .curveLinear,
        animations: @escaping () -> Void) -> ThenableAnimation {
        return AnimationChain(
            previousChain: nil,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            options: options,
            animations: animations
        )
    }
}

/// Chainable animation protocol
public protocol ChainableAnimation {
    
    /// AnimationChain default initializer
    /// - Parameters:
    ///   - previousChain: previous AnimationChain which will be run before this one. pass nil if this is first AnimationChain in chain
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    ///   - dampingRatio: The damping ratio for the spring animation as it approaches its quiescent state.
    ///   To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
    ///   - velocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    ///   A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
    ///   - options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIView.AnimationOptions.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be nil.
    func thenChainAnimate(
        withDuration duration: TimeInterval,
        delay: TimeInterval,
        usingSpringWithDamping dampingRatio: CGFloat,
        initialSpringVelocity velocity: CGFloat,
        options: UIView.AnimationOptions,
        animations: @escaping () -> Void) -> ThenableAnimation
    
    /// Animate all AnimationChain animations with optional completion for when all animation is complete
    /// - Parameter completion: A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be nil.
    func animate(withCompletion completion: ((Bool) -> Void)?)
}

/// Thenable chain animation protocol
public protocol ThenableAnimation: ChainableAnimation {
    
    /// Assign completion for current animation
    /// - Parameter completion: A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be nil.
    /// - Returns: AnimationChain with completion block
    func then(_ completion: @escaping (Bool) -> Void) -> ChainableAnimation
}

public extension ChainableAnimation {
    
    /// AnimationChain default initializer
    /// - Parameters:
    ///   - previousChain: previous AnimationChain which will be run before this one. pass nil if this is first AnimationChain in chain
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    ///   - dampingRatio: The damping ratio for the spring animation as it approaches its quiescent state.
    ///   To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
    ///   - velocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    ///   A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
    ///   - options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIView.AnimationOptions.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be nil.
    func thenChainAnimate(
        withDuration duration: TimeInterval,
        delay: TimeInterval = 0,
        usingSpringWithDamping dampingRatio: CGFloat = 1,
        initialSpringVelocity velocity: CGFloat = 1,
        options: UIView.AnimationOptions = .curveLinear,
        _ animations: @escaping () -> Void) -> ThenableAnimation {
        return thenChainAnimate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: velocity,
            options: options,
            animations: animations
        )
    }
    
    /// Animate all AnimationChain animations
    func animate() {
        animate(withCompletion: nil)
    }
}

/// Chainable animation
public final class AnimationChain: ThenableAnimation {
    
    let previousChain: ThenableAnimation?
    /// The total duration of the animations, measured in seconds.
    public let duration: TimeInterval
    /// The amount of time (measured in seconds) to wait before beginning the animations.
    public let delay: TimeInterval
    /// The damping ratio for the spring animation as it approaches its quiescent state.
    public let dampingRatio: CGFloat
    /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    public let velocity: CGFloat
    /// A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIView.AnimationOptions.
    public let options: UIView.AnimationOptions
    /// A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value.
    public let animations: () -> Void
    /// A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle.
    public internal(set) var completion: ((Bool) -> Void)?
    
    /// AnimationChain default initializer
    /// - Parameters:
    ///   - previousChain: previous AnimationChain which will be run before this one. pass nil if this is first AnimationChain in chain
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    ///   - dampingRatio: The damping ratio for the spring animation as it approaches its quiescent state.
    ///   To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
    ///   - velocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    ///   A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
    ///   - options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIView.AnimationOptions.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be nil.
    public init(previousChain: ThenableAnimation?,
         duration: TimeInterval,
         delay: TimeInterval,
         dampingRatio: CGFloat,
         velocity: CGFloat,
         options: UIView.AnimationOptions,
         animations: @escaping () -> Void) {
        self.previousChain = previousChain
        self.duration = duration
        self.delay = delay
        self.dampingRatio = dampingRatio
        self.velocity = velocity
        self.options = options
        self.animations = animations
    }
    
    public func then(_ completion: @escaping (Bool) -> Void) -> ChainableAnimation {
        self.completion = completion
        return self
    }
    
    public func thenChainAnimate(
        withDuration duration: TimeInterval,
        delay: TimeInterval,
        usingSpringWithDamping dampingRatio: CGFloat,
        initialSpringVelocity velocity: CGFloat,
        options: UIView.AnimationOptions,
        animations: @escaping () -> Void) -> ThenableAnimation {
        return AnimationChain(
            previousChain: self,
            duration: duration,
            delay: delay,
            dampingRatio: dampingRatio,
            velocity: velocity,
            options: options,
            animations: animations
        )
    }
    
    /// it will get previous animate reference till previous animate reference nil.
    /// then if previous animate reference nil, it will run the animate.
    public func animate(withCompletion completion: ((Bool) -> Void)?) {
        guard let previousChain = previousChain else {
            animatingSelf(completion)
            return
        }
        previousChain.animate { completed in
            guard completed else {
                self.completion?(completed)
                completion?(completed)
                return
            }
            self.animatingSelf(completion)
        }
    }
    
    func animatingSelf(_ completion: ((Bool) -> Void)?) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: velocity,
            options: options,
            animations: animations) { completed in
            self.completion?(completed)
            completion?(completed)
        }
    }
}
