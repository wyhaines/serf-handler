module Serf
  module Handler
    class Task
      include Comparable

      attr_accessor :order, :type, :name, :description, :task

      def initialize(type = :query, name = nil, order = 0, description = '', &task)
        @order = order
        @type = type
        @name = name
        @description = description
        @task = task
      end

      def <=>(another_task)
        if @order < another_task.order
          -1
        elsif @order > another_task.order
          1
        else
          if @task.to_s < another_task.task.to_s
            -1
          elsif @task.to_s > another_task.task.to_s
            1
          else
            0
          end
        end
      end

      def call(*args)
        @task.call(*args) if @task
      end

    end
  end
end
