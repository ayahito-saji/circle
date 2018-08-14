class Radius::Radius::Assets
    def initialize(channel)
      @channel = channel
    end
    def run(current_user, pushed_data)
      puts "pushed_data: #{pushed_data}"

      @channel.push current_user, pushed_data
    end
end
