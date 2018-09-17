class Interpreter < ApplicationRecord
  serialize :task_code
  serialize :env
  serialize :sys_env

end
