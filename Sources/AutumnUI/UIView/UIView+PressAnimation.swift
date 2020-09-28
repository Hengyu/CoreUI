//
//  UIView+PressAnimation.swift
//  
//
//  Created by hengyu on 2020/8/20.
//

import UIKit

extension UIView {

    public func animatePressDown() {
        if let state = pressDownState {
            state.animator.isReversed = false
        } else if let state = pressUpState {
            state.animator.isReversed = true
        } else {
            animate(
                duration: Motion.Duration.systemHighlight,
                curve: .easeOut,
                keyPath: \.pressDownState,
                animations: { self.applyPressed(true) },
                reverse: { self.animatePressUp() })
        }
    }

    public func animatePressUp() {
        if let state = pressDownState {
            if state.animator.fractionComplete < 0.01 {
                state.autoreverse = true
            } else {
                state.animator.isReversed = true
            }
        } else if let state = pressUpState {
            state.animator.isReversed = false
        } else {
            animate(
                duration: Motion.Duration.systemHighlight,
                curve: .easeIn,
                keyPath: \.pressUpState,
                animations: { self.applyPressed(false) })
        }
    }

    @nonobjc
    public func applyPressed(_ pressed: Bool) {
        transform = pressed ? .init(scaleX: 0.95, y: 0.95) : .identity
    }

    @nonobjc
    private var pressDownState: AnimatorState? {
        get { objc_getAssociatedObject(self, &Keys.down) as? AnimatorState }
        set { objc_setAssociatedObject(self, &Keys.down, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }

    @nonobjc
    private var pressUpState: AnimatorState? {
        get { objc_getAssociatedObject(self, &Keys.up) as? AnimatorState }
        set { objc_setAssociatedObject(self, &Keys.up, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }

    @nonobjc
    private func animate(
        duration: TimeInterval,
        curve: UIView.AnimationCurve,
        keyPath: ReferenceWritableKeyPath<UIView, AnimatorState?>,
        animations: @escaping () -> Void,
        reverse: (() -> Void)? = nil)
    {
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve, animations: animations)
        self[keyPath: keyPath] = AnimatorState(animator: animator)
        animator.addCompletion { [weak self] position in
            guard let self = self, let state = self[keyPath: keyPath] else { return }

            self[keyPath: keyPath] = nil

            if case .end = position, state.autoreverse {
                reverse?()
            }
        }

        animator.startAnimation()
    }
}

// MARK: - Keys

private enum Keys {
    static var down: Int = 0
    static var up: Int = 0
}

// MARK: - AnimatorState

/// The state associated with a press down animation
private class AnimatorState {

    let animator: UIViewPropertyAnimator
    /// Whether this animator should be reversed on completion, if possible,
    var autoreverse: Bool

    init(animator: UIViewPropertyAnimator, autoreverse: Bool = false) {
        self.animator = animator
        self.autoreverse = autoreverse
    }
}
