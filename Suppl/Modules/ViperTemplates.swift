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


// BuildingRouter

typealias ViperBuildingRouter = ViperRouter & ViperBuilderProtocol


// ModuleID

struct ViperModuleID<TYPE: ViperBaseRouter>: Equatable {
    let value: String
    
    fileprivate static func generate<TYPE: ViperBaseRouter>(_ type: TYPE.Type? = nil) -> ViperModuleID<TYPE> {
        return .init(value: "\(NSStringFromClass(TYPE.self))-\(arc4random_uniform(1000000001))")
    }
    
    private init(value: String) {
        self.value = value
    }
    
}


// BuilderProtocol

protocol ViperBuilderProtocol {
    associatedtype VIEW: UIViewController & ViperViewProtocol
    associatedtype PRESENTER: ViperBasePresenter
    associatedtype ROUTER: ViperBaseRouter & ViperBuilderProtocol = Self
    associatedtype INTERACTOR: ViperBaseIntercator
}

extension ViperBuilderProtocol {
    
    static func generateModuleId() -> ViperModuleID<ROUTER> {
        return .generate()
    }
    
    static func setup(moduleId: ViperModuleID<ROUTER>? = nil, args: [String: Any] = [:]) -> UIViewController {
        let moduleId = moduleId ?? generateModuleId()
        
        let view = VIEW(moduleId: moduleId.value, args: args) as! UIViewController & ViperBaseViewProtocol
        let presenter = PRESENTER(moduleId: moduleId.value, args: args)
        let router = ROUTER(moduleId: moduleId.value, args: args)
        let interactor = INTERACTOR(moduleId: moduleId.value, args: args)
        
        view._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._view = view
        router._view = view
        interactor._presenter = presenter
        
        return view
    }
    
}
