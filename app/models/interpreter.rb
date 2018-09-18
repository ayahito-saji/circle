class Interpreter < ApplicationRecord
  require 'securerandom'
  serialize :task_code
  serialize :env
  serialize :sys_env

  before_create :setup_interpreter
  after_create :setup_processor

  def onload(user_id)
    puts "!!!!onload!!!!#{self.processor_id} #{user_id}"
  end

  def action(user_id, data)
    $processors[self.processor_id]
  end

  # プロセッサーが正常終了したら呼ばれる
  def finish_processor(env, sys_env)
    self.update_attributes(env: env, sys_env: sys_env)
    $processors.delete(self.processor_id)
    puts "Deleted processor because of finished processor"
    puts "$processors"
    pp $processors
  end

  # プロセッサが異常終了したら呼ばれる
  def exit_processor(e)
    $processors.delete(self.processor_id)
    puts "Deleted processor because of exited processor #{e}"
    puts "$processors"
    pp $processors
  end

  # プロセッサがTLEで終了したら呼ばれる
  def tle_processor
    $processors.delete(self.processor_id)
    puts "Deleted processor because of tle processor"
    puts "$processors"
    pp $processors
  end

  private
  # インタプリタの立ち上げ（ゲーム開始時）
  def setup_interpreter
    self.processor_id = SecureRandom.base58(20)
    self.env = {}
    self.sys_env = {}
  end
  # プロセスの立ち上げ（各ゲーム内のアクションごと）
  def setup_processor
    if $processors[self.processor_id].nil?
      task_code = []
      task_code = Rulebook.find_by(id: self.rulebook_id).task_code if self.rulebook_id
      task_code = self.task_code if self.task_code
      $processors[self.processor_id] = Radius::RadiusProcessor.new(self, task_code, self.env, self.sys_env)
    end
    puts "Created processor"
    puts "$processors"
    pp $processors
  end
end
