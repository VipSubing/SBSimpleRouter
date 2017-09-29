Pod::Spec.new do |s|
    s.name         = 'SBSimpleRouter'
    s.version      = '1.0.0'
    s.summary      = '一个便捷的路由解决方案'
    s.homepage     = 'https://github.com/pubin563783417/SBSimpleRouter'
    s.license      = 'MIT'
    s.authors      = {'subing' => '15557109308@163.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/pubin563783417/SBSimpleRouter.git', :tag => s.version}
    s.source_files = '路由/simple路由/*.{h,m}'
    s.requires_arc = true
end
