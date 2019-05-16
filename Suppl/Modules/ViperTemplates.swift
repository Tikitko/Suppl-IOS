import Foundation
import UIKit

// VIPER TEMPLATES


// View: Protocols

protocol ViperViewProtocol: class {
    init(moduleId: String, args: [String : Any])
}

private protocol ViperBaseViewProtocol: class {
    var _presenter: ViperBasePresenterProtocol? { get set }
    init(moduleId: String, args: [String : Any])
}


// View: UIViewController

class ViperBaseDefaultView: UIViewController, ViperViewProtocol, ViperBaseViewProtocol {
    fileprivate var _presenter: ViperBasePresenterProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(moduleId: String, args: [String : Any]) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
}

class ViperDefaultView<PRESENTER>: ViperBaseDefaultView {
    var presenter: PRESENTER! {
        return _presenter as? PRESENTER
    }
}


// View: OldSafeAreaViewController

class ViperBaseOldSafeAreaDefaultView: OldSafeAreaViewController, ViperViewProtocol, ViperBaseViewProtocol {
    fileprivate var _presenter: ViperBasePresenterProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(moduleId: String, args: [String : Any]) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
}

class ViperOldSafeAreaDefaultView<PRESENTER>: ViperBaseOldSafeAreaDefaultView {
    var presenter: PRESENTER! {
        return _presenter as? PRESENTER
    }
}


// View: UITableViewController

class ViperBaseTableView: UITableViewController, ViperViewProtocol, ViperBaseViewProtocol {
    fileprivate var _presenter: ViperBasePresenterProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(moduleId: String, args: [String : Any]) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
}

class ViperTableView<PRESENTER>: ViperBaseTableView {
    var presenter: PRESENTER! {
        return _presenter as? PRESENTER
    }
}


// View: UITableViewController

class ViperBaseCollectionView: UICollectionViewController, ViperViewProtocol, ViperBaseViewProtocol {
    fileprivate var _presenter: ViperBasePresenterProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(moduleId: String, args: [String : Any]) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
}

class ViperCollectionView<PRESENTER>: ViperBaseCollectionView {
    var presenter: PRESENTER! {
        return _presenter as? PRESENTER
    }
}


// Presenter

private protocol ViperBasePresenterProtocol: class {
    var _router: ViperBaseRouterProtocol? { get set }
    var _interactor: ViperBaseInteractorProtocol? { get set }
    var _view: ViperBaseViewProtocol? { get set }
    init(moduleId: String, args: [String : Any])
}

class ViperBasePresenter: ViperBasePresenterProtocol {
    fileprivate var _router: ViperBaseRouterProtocol?
    fileprivate var _interactor: ViperBaseInteractorProtocol?
    fileprivate weak var _view: ViperBaseViewProtocol?
    
    required init(moduleId: String, args: [String : Any]) {}
    init() {}
    
}

class ViperPresenter<ROUTER, INTERACTOR, VIEW>: ViperBasePresenter {
    var router: ROUTER! {
        return _router as? ROUTER
    }
    var interactor: INTERACTOR! {
        return _interactor as? INTERACTOR
    }
    var view: VIEW! {
        return _view as? VIEW
    }
}


// Interactor

private protocol ViperBaseInteractorProtocol: class {
    var _presenter: ViperBasePresenterProtocol? { get set }
    init(moduleId: String, args: [String : Any])
}

class ViperBaseIntercator: ViperBaseInteractorProtocol {
    fileprivate weak var _presenter: ViperBasePresenterProtocol?
    
    required init(moduleId: String, args: [String : Any]) {}
    init() {}
    
}

class ViperInteractor<PRESENTER>: ViperBaseIntercator {
    var presenter: PRESENTER! {
        return _presenter as? PRESENTER
    }
}


// Router

private protocol ViperBaseRouterProtocol: class {
    var _view: ViperBaseViewProtocol? { get set }
    init(moduleId: String, args: [String : Any])
}

class ViperBaseRouter: ViperBaseRouterProtocol {
    fileprivate weak var _view: ViperBaseViewProtocol?
    
    required init(moduleId: String, args: [String : Any]) {}
    init() {}
    
}

class ViperRouter: ViperBaseRouter {
    var viewController: UIViewController! {
        return _view as? UIViewController
    }
}


// AssemblyRouter

typealias ViperAssemblyRouter = ViperRouter & ViperBuilderProtocol


// Builder

typealias ViperBuilderProtocol = ViperBuildInfoProtocol & ViperBuildableProtocol

protocol ViperBuildInfoProtocol {
    associatedtype VIEW: UIViewController & ViperViewProtocol
    associatedtype PRESENTER: ViperBasePresenter
    associatedtype INTERACTOR: ViperBaseIntercator
    associatedtype ROUTER: ViperBaseRouter & ViperBuildInfoProtocol = Self
}

protocol ViperBuildableProtocol {
    static func setup(args: [String: Any]) -> (id: String, viewController: UIViewController)
    static func setup(submodulesBuilders: [String: ViperBuildableProtocol.Type], args: [String: Any]) -> (submodulesIds: [String: String], id: String, viewController: UIViewController)
}

extension ViperBuildableProtocol where Self: ViperBuildInfoProtocol {
    
    private static func generateModuleId() -> String {
        return "\(arc4random_uniform(1000000001)):\(Date().timeIntervalSince1970):\(NSStringFromClass(ROUTER.self))"
    }
    
    private static func setup(moduleId: String, args: [String: Any]) -> UIViewController {
        let view = VIEW(moduleId: moduleId, args: args) as! ViperBaseViewProtocol
        let presenter = PRESENTER(moduleId: moduleId, args: args)
        let interactor = INTERACTOR(moduleId: moduleId, args: args)
        let router = ROUTER(moduleId: moduleId, args: args)
        
        view._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._view = view
        interactor._presenter = presenter
        router._view = view
        
        return view as! UIViewController
    }
    
    static func setup(args: [String: Any]) -> (id: String, viewController: UIViewController) {
        let moduleId = generateModuleId()
        return (moduleId, setup(moduleId: moduleId, args: args))
    }
    
    static func setup(submodulesBuilders: [String: ViperBuildableProtocol.Type], args: [String: Any]) -> (submodulesIds: [String: String], id: String, viewController: UIViewController) {
        let moduleId = generateModuleId()
        
        var submodulesIds = [String: String]()
        var submodulesControllers = [String: UIViewController]()
        for (submoduleName, submoduleBuilder) in submodulesBuilders {
            let submoduleInfo = submoduleBuilder.setup(args: args.merging(["parentModuleId": moduleId], uniquingKeysWith: { $1 }))
            submodulesIds[submoduleName] = submoduleInfo.id
            submodulesControllers[submoduleName] = submoduleInfo.viewController
        }
        
        let viewController = setup(moduleId: moduleId, args: args.merging(submodulesControllers, uniquingKeysWith: { $1 }))
        return (submodulesIds, moduleId, viewController)
    }
    
}
