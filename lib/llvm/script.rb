require 'rubygems'
require 'llvm/core'
require 'llvm/execution_engine'
require 'llvm/transforms/ipo'
require 'llvm/transforms/scalar'

require File.dirname(__FILE__) + '/script/struct'
require File.dirname(__FILE__) + '/linker'
require File.dirname(__FILE__) + '/ext'

require File.dirname(__FILE__) + '/script/core'
require File.dirname(__FILE__) + '/script/platform'
require File.dirname(__FILE__) + '/script/types'
require File.dirname(__FILE__) + '/script/function'
require File.dirname(__FILE__) + '/script/generator'
require File.dirname(__FILE__) + '/script/namespace'
require File.dirname(__FILE__) + '/script/library'
require File.dirname(__FILE__) + '/script/program'