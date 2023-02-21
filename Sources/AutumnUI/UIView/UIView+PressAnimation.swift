//
//  MIT LICENSE
//
//  Created by hengyu on 2020/8/20.
//  Copyright © 2020-2023 hengyu. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

extension UIView {

    @MainActor
    public func animatePressDown() {
        if let pressDownState {
            pressDownState.animator.isReversed = false
        } else if let pressUpState {
            pressUpState.animator.isReversed = true
        } else {
            animate(
                duration: Motion.Duration.systemHighlight,
                curve: .easeOut,
                keyPath: \.pressDownState,
                animations: { self.applyPressed(true) },
                reverse: { self.animatePressUp() })
        }
    }

    @MainActor
    public func animatePressUp() {
        if let pressDownState {
            if pressDownState.animator.fractionComplete < 0.01 {
                pressDownState.autoreverse = true
            } else {
                pressDownState.animator.isReversed = true
            }
        } else if let pressUpState {
            pressUpState.animator.isReversed = false
        } else {
            animate(
                duration: Motion.Duration.systemHighlight,
                curve: .easeIn,
                keyPath: \.pressUpState,
                animations: { self.applyPressed(false) })
        }
    }

    @nonobjc
    @MainActor
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
            guard let self, let state = self[keyPath: keyPath] else { return }

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
