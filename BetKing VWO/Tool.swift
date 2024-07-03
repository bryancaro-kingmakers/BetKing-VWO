//
//  Tool.swift
//  BetKing VWO
//
//  Created by Bryan Caro on 2/7/24.
//

import UIKit

final class RootCoordinator: BaseCoordinator {
    private lazy var window = UIWindow(frame: UIScreen.main.bounds)
    private lazy var rootVC = UIViewController()
    private let containerBuilder: ContainerBuilder
    
    init(containerBuilder: ContainerBuilder) {
        self.containerBuilder = containerBuilder
    }
    
    override func start() {
        super.start()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        coordinateToSplashScreen()
    }
    
    private func coordinateToSplashScreen() {
        let container = containerBuilder.splashScreen()
        let coordinator = SplashScreenViewCoordinator(container: container, parent: rootVC)
        
        coordinate(to: coordinator)
    }
}


final class SplashScreenViewCoordinator: BaseCoordinator {
    private let container: SplashScreenStageContainer
    private weak var parent: UIViewController?
    
    init(container: SplashScreenStageContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        super.start()
        guard let parent = parent else { return }
        
        let viewController = ViewController()
        parent.setContentViewController(viewController)
    }
    
    override func complete() {
        super.complete()
        guard let vc = self.parent?.children
            .compactMap({ $0 as? ViewController })
            .first else { return }
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}


struct ContainerBuilder {
    let splashScreen: () -> SplashScreenStageContainer
}

protocol SplashScreenStageContainer {
}


struct RealSplashScreenStageContainer: SplashScreenStageContainer {
}

#if DEBUG
struct FakeSplashScreenStageContainer: SplashScreenStageContainer {
}
#endif

class BaseCoordinator {
    private weak var parent: BaseCoordinator?
    private var children: [BaseCoordinator] = []
    
    func coordinate(to coordinator: BaseCoordinator) {
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
    
    func start() {
    }
    
    func complete() {
        parent?.remove(coordinator: self)
    }
    
    var onComplete: Void = () {
        didSet { complete() }
    }
    
    // MARK: - Private
    private func remove(coordinator: BaseCoordinator) {
        if let index = children.firstIndex(where: { $0 === coordinator }) {
            children.remove(at: index)
        }
        coordinator.parent = nil
    }
    
    private var name: String {
        String(describing: type(of: self))
    }
}

extension UIViewController {
    func setContentViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        animationOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .curveEaseInOut]
    ) {
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.frame = view.bounds
        
        if animated {
            UIView.transition(with: view, duration: 0.75, options: animationOptions, animations: {
                for subview in self.view.subviews {
                    subview.removeFromSuperview()
                }
                self.view.addSubview(viewController.view)
                
                viewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).rotated(by: .pi / 8)
                UIView.animate(withDuration: 0.75, delay: 0, options: [.curveEaseInOut], animations: {
                    viewController.view.transform = .identity
                }, completion: nil)
            }) { completed in
                viewController.didMove(toParent: self)
            }
        } else {
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
            self.view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
}
