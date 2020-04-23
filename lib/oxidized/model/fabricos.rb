class FabricOS < Oxidized::Model
  # Brocade Fabric OS model #

  prompt /^([\w-]+:+[\w-]+[>]\s)$/
  comment '# '

  cmd :all do |cfg|
    cfg = cfg.cut_both
    cfg = cfg + "\n"
  end

  cmd :secret do |cfg|
    cfg.gsub!(/([s]Secret:)\S+/, '\1 SECRET REMOVED')
    cfg.gsub!(/(http.sl.user:)\S+/, '\1 SECRET REMOVED')
  end

  cmd 'chassisShow' do |cfg|
    comment cfg.each_line.reject { |line| line.match(/Time Awake:/) || line.match(/Power Usage \(Watts\):/) || line.match(/Time Alive:/) || line.match(/Update:/) }.join
  end

  cmd 'version' do |cfg|
    comment cfg
  end

  cmd 'configShow -all' do |cfg|
    cfg = cfg.each_line.reject { |line| line.match /date = / }.join
    cfg
  end

  cfg :ssh do
    pre_logout 'exit'
  end
end

