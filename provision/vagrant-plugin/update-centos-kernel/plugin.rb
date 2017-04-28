require File.expand_path("../middleware/kernel_updater", __FILE__)

module UpdateCentOSKernel
  class Plugin < Vagrant.plugin('2')
    name 'update-centos-kernel'

    action_hook(name, :machine_action_up) do |hook|
      if defined?(VagrantVbguest::Middleware)
        hook.after(VagrantPlugins::ProviderVirtualBox::Action::CheckGuestAdditions, UpdateCentOSKernel::Middleware::KernelUpdater)
      end
    end
  end
end