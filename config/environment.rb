require 'bundler'
require 'audite'
require 'mpg123'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
# 
 ActiveRecord::Base.logger.level = 1
# require_all 'lib'
require 'require_all'
require_rel ('../lib')
