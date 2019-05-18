import Foundation
import UIKit

// VIPER TEMPLATES


// View: Protocols

protocol ViperViewProtocol: class {
    init(moduleId: String, parentModuleId: String?, args: [String : Any])
}

private protocol ViperBaseViewProtocol: class {
    var _presenter: ViperBasePresenterProtocol? { get set }
    init(moduleId: String, parentModuleId: String?, args: [String : Any])
}


// View: UIViewController

class ViperBaseDefaultView: UIViewController, ViperViewProtocol, ViperBaseViewProtocol {
    fileprivate var _presenter: ViperBasePresenterProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
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
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
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
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
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
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
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
    init(moduleId: String, parentModuleId: String?, args: [String : Any])
}

class ViperBasePresenter: ViperBasePresenterProtocol {
    fileprivate var _router: ViperBaseRouterProtocol?
    fileprivate var _interactor: ViperBaseInteractorProtocol?
    fileprivate weak var _view: ViperBaseViewProtocol?
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {}
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
    init(moduleId: String, parentModuleId: String?, args: [String : Any])
}

class ViperBaseIntercator: ViperBaseInteractorProtocol {
    fileprivate weak var _presenter: ViperBasePresenterProtocol?
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {}
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
    init(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleNamedBuilder], args: [String : Any])
}

class ViperBaseRouter: ViperBaseRouterProtocol {
    fileprivate weak var _view: ViperBaseViewProtocol?
    
    required init(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleNamedBuilder], args: [String : Any]) {}
    init() {}
    
}

class ViperRouter: ViperBaseRouter {
    var viewController: UIViewController! {
        return _view as? UIViewController
    }
}


// AssemblyRouter

typealias ViperAssemblyRouter = ViperRouter & ViperModuleBuilderProtocol


// ModuleBuilder

typealias ViperModuleBuilderProtocol = ViperModuleBuildComponentsProtocol & ViperModuleBuildableProtocol

protocol ViperModuleBuildComponentsProtocol {
    associatedtype VIEW: UIViewController & ViperViewProtocol
    associatedtype PRESENTER: ViperBasePresenter
    associatedtype INTERACTOR: ViperBaseIntercator
    associatedtype ROUTER: ViperBaseRouter & ViperModuleBuildComponentsProtocol = Self
}

typealias ViperModuleInfo = (id: String, viewController: UIViewController)

struct ViperModuleBuilderInfo {
    let name: String
    let type: ViperModuleBuildableProtocol.Type
    let submodulesBuildersInfo: [ViperModuleBuilderInfo]
}

typealias ViperModuleBuilder = (_ buildInfo: ViperModuleBuildInfo) -> ViperModuleInfo
typealias ViperModuleNamedBuilder = (name: String, builder: ViperModuleBuilder)

struct ViperModuleBuildInfo {
    let args: [String: Any]
    fileprivate let parentModuleId: String?
    init(_ args: [String: Any] = [:]) {
        self.args = args
        self.parentModuleId = nil
    }
    fileprivate init(_ args: [String: Any] = [:], parentModuleId: String) {
        self.args = args
        self.parentModuleId = parentModuleId
    }
}

protocol ViperModuleBuildableProtocol {
    static func build(submodulesBuildersInfo: [ViperModuleBuilderInfo], buildInfo: ViperModuleBuildInfo) -> ViperModuleInfo
}

extension ViperModuleBuildableProtocol where Self: ViperModuleBuildComponentsProtocol {
    
    private static func generateModuleId() -> String {
        return "\(arc4random_uniform(1000001)):\(Int(Date().timeIntervalSince1970)):\(NSStringFromClass(ROUTER.self))"
    }
    
    private static func build(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleNamedBuilder], args: [String: Any]) -> UIViewController {
        let view = VIEW(moduleId: moduleId, parentModuleId: parentModuleId, args: args) as! ViperBaseViewProtocol
        let presenter = PRESENTER(moduleId: moduleId, parentModuleId: parentModuleId, args: args)
        let interactor = INTERACTOR(moduleId: moduleId, parentModuleId: parentModuleId, args: args)
        let router = ROUTER(moduleId: moduleId, parentModuleId: parentModuleId, submodulesBuilders: submodulesBuilders, args: args)
        
        view._presenter = presenter
        presenter._interactor = interactor
        presenter._router = router
        presenter._view = view
        interactor._presenter = presenter
        router._view = view
        
        return view as! UIViewController
    }
    
    static func build(submodulesBuildersInfo: [ViperModuleBuilderInfo] = [], buildInfo: ViperModuleBuildInfo = .init()) -> ViperModuleInfo {
        let moduleId = generateModuleId()
        let parentModuleId = buildInfo.parentModuleId
        let submodulesBuilders: [ViperModuleNamedBuilder] = submodulesBuildersInfo
            .map { builderInfo -> ViperModuleNamedBuilder in
                return (builderInfo.name, { builderInfo.type.build(submodulesBuildersInfo: builderInfo.submodulesBuildersInfo, buildInfo: .init($0.args, parentModuleId: moduleId)) })
            }
        let args = buildInfo.args
        return (moduleId, build(moduleId: moduleId, parentModuleId: parentModuleId, submodulesBuilders: submodulesBuilders, args: args))
    }
    
}
