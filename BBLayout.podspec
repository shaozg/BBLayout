@version = "0.0.3"

Pod::Spec.new do |s|

  s.name         = "BBLayout"        #SDK name
  s.version      = @version          #SDK version
  s.summary      = "BBLayou"         #
  s.description  = "BBLayout 依赖性低，支持多行布局"    #
  s.homepage     = "https://github.com/shaozg/BBLayout" #
  s.license      = "MIT"            #必填，保持"MIT"就好
  s.author       = { "shaozg" => "shaozg1101@126.com" }  #建议填写，SDK作者
  s.platform     = :ios, "7.0"      #必填，
  s.ios.deployment_target = '7.0'   #必填
  s.source       = { :git => "https://github.com/shaozg/BBLayout.git", :tag => "v#{s.version}" } #建议填写，工程位置

  #SDK源文件，不同的目录集间使用逗号分开
  s.source_files = "BBLayout/Class/*.{h,m}"

  #SDK公开头文件，不同的目录集间使用逗号分开
  s.public_header_files = "BBLayout/Class/*.h"
  s.requires_arc = true

end
