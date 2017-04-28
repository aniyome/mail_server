module UpdateCentOSKernel
  module Middleware
    class KernelUpdater
      @@updated = {};

      # constractor
      def initialize(app, env)
        @app = app
      end

      def call(env)
        @env = env
        @vm = env[:machine]
        @ui = env[:ui]

        if @@updated[@vm.id]
          # kernelが更新済みの場合は処理を行わない
          @ui.info('[kernel_updater.rb] Kernel has been updated')
        else
          @@updated[@vm.id] = true
          update_kernel
          reboot
        end

        @app.call(env)
      end

      def update_kernel()
        @ui.info '[kernel_updater.rb] Updating kernel'
        @vm.communicate.sudo('yum install -y --disablerepo=* --enablerepo=C7.0.1406-base --enablerepo=C7.0.1406-updates kernel kernel-devel') do |type, data|
          if type == :stderr
            @ui.error(data);
          else
            @ui.info(data);
          end
        end
      end

      def reboot()
        @ui.info('[kernel_updater.rb] Rebooting after updating kernel')
        simple_reboot = Vagrant::Action::Builder.new.tap do |builder|
          # ゲストOSのシャットダウン
          builder.use VagrantPlugins::ProviderVirtualBox::Action::action_halt

          # ゲストOSの起動
          builder.use VagrantPlugins::ProviderVirtualBox::Action::Boot
          # 起動後の待機処理を実行
          if defined?(Vagrant::Action::Builtin::WaitForCommunicator)
            builder.use Vagrant::Action::Builtin::WaitForCommunicator, [:starting, :running]
          end

          # ゲストOSのバージョン再チェック
          builder.use VagrantVbguest::Middleware
        end
        # 再起動アクションをランナーに追加
        @env[:action_runner].run simple_reboot, @env
      end
    end
  end
end
