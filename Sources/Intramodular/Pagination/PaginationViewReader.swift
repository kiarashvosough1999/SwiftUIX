//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)

import Swift
import SwiftUI

/// A proxy value allowing the pagination views within a view hierarchy to be manipulated programmatically.
public struct PaginationViewProxy {
    private let _progressionController = ReferenceBox<ProgressionController?>(nil)
    private let _hostingPageViewController = WeakReferenceBox<AnyObject>(nil)
    
    var hostingPageViewController: _opaque_UIHostingPageViewController? {
        get {
            _hostingPageViewController.value as? _opaque_UIHostingPageViewController
        } set {
            _hostingPageViewController.value = newValue
        }
    }
    
    var progressionController: ProgressionController {
        get {
            _progressionController.value!
        } set {
            _progressionController.value = newValue
        }
    }
    
    public func moveToPrevious() {
        progressionController.moveToPrevious()
    }

    public func moveToNext() {
        progressionController.moveToNext()
    }
}

/// A view whose child is defined as a function of a `PaginationViewProxy` targeting the pagination views within the child.
public struct PaginationViewReader<Content: View>: View {
    public let content: (PaginationViewProxy) -> Content
    
    @State public var _paginationViewProxy = PaginationViewProxy()
    
    @inlinable
    public init(
        @ViewBuilder content: @escaping (PaginationViewProxy) -> Content
    ) {
        self.content = content
    }
    
    @inlinable
    public var body: some View {
        content(_paginationViewProxy)
            .environment(\._paginationViewProxy, $_paginationViewProxy)
    }
}

// MARK: - Auxiliary Implementation -

extension PaginationViewProxy {
    fileprivate struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static let defaultValue: Binding<PaginationViewProxy>? = nil
    }
}

extension EnvironmentValues {
    @usableFromInline
    var _paginationViewProxy: Binding<PaginationViewProxy>? {
        get {
            self[PaginationViewProxy.EnvironmentKey]
        } set {
            self[PaginationViewProxy.EnvironmentKey] = newValue
        }
    }
}

#endif
