module Grant
  class Config
    attr_reader :actions

    def self.valid_actions
      @valid_actions ||= [:create, :find, :update, :destroy]
    end

    def initialize(*args)
      @actions = args.map(&:to_sym)
      validate_actions(@actions)
    end

  private

    def validate_actions(actions)
      raise Grant::Error.new "at least one action in #{Config.valid_actions.inspect} must be specified" if actions.empty?
      raise Grant::Error.new "#{Config.valid_actions.inspect} are the only valid actions" unless actions.all? { |a| Config.valid_actions.include?(a.to_sym) }
    end

  end
end
