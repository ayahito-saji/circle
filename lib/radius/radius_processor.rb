module Radius
  class RadiusProcessor
    def initialize(interpreter, task_code, env, sys_env)
      @interpreter = interpreter
      @task_code = task_code
      @env = env
      @sys_env = sys_env
    end
    def run
      kill_thread @main_thread
      # TLE監視スレッドを立てる
      @tle_thread = Thread.start do
        puts "Started RadiusProcesserTLEThread"
        sleep 1
        kill_thread @main_thread
        # TLE終了
        puts "Finished RadiusProcesserTLEThread"
        @interpreter.tle_processor
      end
      # メインスレッドを立てる
      @main_thread = Thread.start do
        puts "Started RadiusProcesserMainThread"
        begin
          radius = Radius::RadiusMain.new
          @env, @sys_env = radius.process(@task_code, @env, @sys_env)
          kill_thread @tle_thread
          # 正常終了
          puts "Finished RadiusProcesserMainThread"
          @interpreter.finish_processor(@env, @sys_env)

        rescue => e
          puts "Stopped RadiusProcesserMainThread"

          kill_thread @tle_thread
          # エラー終了
          @interpreter.exit_processor(e)

        end
      end
    end

    private
    def kill_thread(thread)
      if thread && thread.alive?
        thread.kill
      end
    end
  end
end