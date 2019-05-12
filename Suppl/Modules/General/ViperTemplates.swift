import Foundation
import UIKit

// View
protocol ViperViewProtocol: class {
    init(moduleId: String, args: [String : Any])
}
fileprivate protocol ViperViewConfiguratorProtocol {
    func setPresenter(_ presenter: AnyObject)
}
class ViperDefaultView<PRESENTER>: UIViewController, ViperViewProtocol {
    private var _presenter: StrongReference<PRESENTER>!
    var presenter: PRESENTER! { return _presenter.pointee }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    init() { super.init(nibName: nil, bundle: nil) }
    required init(moduleId: String, args: [String : Any]) { super.init(nibName: nil, bundle: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
extension ViperDefaultView: ViperViewConfiguratorProtocol {
    fileprivate func setPresenter(_ presenter: AnyObject) { _presenter = .init(presenter) }
}
class ViperOldSafeAreaDefaultView<PRESENTER>: OldSafeAreaViewController, ViperViewProtocol {
    private var _presenter: StrongReference<PRESENTER>!
    var presenter: PRESENTER! { return _presenter.pointee }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    init() { super.init(nibName: nil, bundle: nil) }
    required init(moduleId: String, args: [String : Any]) { super.init(nibName: nil, bundle: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
extension ViperOldSafeAreaDefaultView: ViperViewConfiguratorProtocol {
    fileprivate func setPresenter(_ presenter: AnyObject) { _presenter = .init(presenter) }
}
class ViperTableView<PRESENTER>: UITableViewController, ViperViewProtocol {
    private var _presenter: StrongReference<PRESENTER>!
    var presenter: PRESENTER! { return _presenter.pointee }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    init() { super.init(nibName: nil, bundle: nil) }
    required init(moduleId: String, args: [String : Any]) { super.init(nibName: nil, bundle: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
extension ViperTableView: ViperViewConfiguratorProtocol {
    fileprivate func setPresenter(_ presenter: AnyObject) { _presenter = .init(presenter) }
}
class ViperCollectionView<PRESENTER>: UICollectionViewController, ViperViewProtocol {
    private var _presenter: StrongReference<PRESENTER>!
    var presenter: PRESENTER! { return _presenter.pointee }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
    init() { super.init(nibName: nil, bundle: nil) }
    required init(moduleId: String, args: [String : Any]) { super.init(nibName: nil, bundle: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
extension ViperCollectionView: ViperViewConfiguratorProtocol {
    fileprivate func setPresenter(_ presenter: AnyObject) { _presenter = .init(presenter) }
}

// Presenter
protocol ViperPresenterProtocol: class {
    init(moduleId: String, args: [String : Any])
}
fileprivate protocol ViperPresenterConfiguratorProtocol {
    func setRouter(_ router: AnyObject)
    func setInteractor(_ interactor: AnyObject)
    func setView(_ view: AnyObject)
}
class ViperPresenter<ROUTER, INTERACTOR, VIEW>: ViperPresenterProtocol {
    private var _router: StrongReference<ROUTER>!
    private var _interactor: StrongReference<INTERACTOR>!
    private var _view: WeakReference<VIEW>!
    var router: ROUTER! { return _router.pointee }
    var interactor: INTERACTOR! { return _interactor.pointee }
    var view: VIEW! { return _view.pointee }
    init() {}
    required init(moduleId: String, args: [String : Any]) {}
}
extension ViperPresenter: ViperPresenterConfiguratorProtocol {
    fileprivate func setRouter(_ router: AnyObject) { _router = .init(router) }
    fileprivate func setInteractor(_ interactor: AnyObject) { _interactor = .init(interactor) }
    fileprivate func setView(_ view: AnyObject) { _view = .init(view) }
}

// Router
protocol ViperRouterProtocol: class {
    init(moduleId: String, args: [String : Any])
}
fileprivate protocol ViperRouterConfiguratorProtocol {
    func setViewController(_ viewController: UIViewController)
}
class ViperRouter: ViperRouterProtocol {
    private var _viewController: WeakReference<UIViewController>!
    var viewController: UIViewController! { return _viewController.pointee }
    init() {}
    required init(moduleId: String, args: [String : Any]) {}
}
extension ViperRouter: ViperRouterConfiguratorProtocol {
    fileprivate func setViewController(_ viewController: UIViewController) { _viewController = .init(viewController) }
}

// Interactor
protocol ViperInteractorProtocol: class {
    init(moduleId: String, args: [String : Any])
}
fileprivate protocol ViperInteractorConfiguratorProtocol: class {
    func setPresenter(_ presenter: AnyObject)
}
class ViperInteractor<PRESENTER>: ViperInteractorProtocol {
    fileprivate var _presenter: WeakReference<PRESENTER>!
    var presenter: PRESENTER! { return _presenter.pointee }
    init() {}
    required init(moduleId: String, args: [String : Any]) {}
}
extension ViperInteractor: ViperInteractorConfiguratorProtocol {
    fileprivate func setPresenter(_ presenter: AnyObject) { _presenter = .init(presenter) }
}

// ModuleID
struct ViperModuleID<TYPE: ViperRouterProtocol>: Equatable {
    let value: String
    fileprivate init(_ type: TYPE.Type? = nil) { value = .init(describing: "\(NSStringFromClass(TYPE.self))-\(arc4random_uniform(1000000001))") }
}

// Constructor
protocol ViperConstructorProtocol {
    associatedtype VIEW: UIViewController & ViperViewProtocol
    associatedtype PRESENTER: ViperPresenterProtocol
    associatedtype ROUTER: ViperRouterProtocol & ViperConstructorProtocol = Self
    associatedtype INTERACTOR: ViperInteractorProtocol
}
extension ViperConstructorProtocol {
    static func generateModuleId() -> ViperModuleID<ROUTER> { return .init() }
    static func setup(moduleId: ViperModuleID<ROUTER>? = nil, args: [String: Any] = [:]) -> UIViewController {
        let moduleId = moduleId ?? generateModuleId()
        let view = VIEW(moduleId: moduleId.value, args: args) as! UIViewController & ViperViewProtocol & ViperViewConfiguratorProtocol
        let presenter = PRESENTER(moduleId: moduleId.value, args: args) as! ViperPresenterProtocol & ViperPresenterConfiguratorProtocol
        let router = ROUTER(moduleId: moduleId.value, args: args) as! ViperRouterProtocol & ViperRouterConfiguratorProtocol
        let interactor = INTERACTOR(moduleId: moduleId.value, args: args) as! ViperInteractorProtocol & ViperInteractorConfiguratorProtocol
        view.setPresenter(presenter)
        presenter.setInteractor(interactor)
        presenter.setRouter(router)
        presenter.setView(view)
        router.setViewController(view)
        interactor.setPresenter(presenter)
        return view
    }
}
