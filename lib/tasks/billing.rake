namespace :billing do
  desc "Atualiza status financeiros automáticos dos clientes"
  task update_statuses: :environment do
    BillingStatusUpdater.run!
    puts "Rotina de atualização de status financeiro concluída."
  end
end
