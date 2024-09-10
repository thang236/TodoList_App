//
//  HalfSizePresentationController.swift
//  TodoList_App
//
//  Created by Louis Macbook on 28/08/2024.
//

import UIKit

class HalfSizePresentationController: UIPresentationController {
    private var dimmingView: UIView!

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }

    private func setupDimmingView() {
        dimmingView = UIView(frame: containerView?.bounds ?? CGRect.zero)

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = dimmingView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        blurEffectView.alpha = 0.8

        dimmingView.addSubview(blurEffectView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 1.0
        containerView.addSubview(dimmingView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }) { _ in
            self.dimmingView.removeFromSuperview()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        let height = containerView.bounds.height * 0.7
        let originY = containerView.bounds.height - height
        return CGRect(x: 0, y: originY, width: containerView.bounds.width, height: height)
    }

    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
