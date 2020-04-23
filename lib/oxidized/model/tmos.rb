class TMOS < Oxidized::Model
  comment  '# '

  cmd :secret do |cfg|
    cfg.gsub!(/^([\s\t]*)secret \S+/, '\1secret <secret removed>')
    cfg.gsub!(/^([\s\t]*\S*)password \S+/, '\1password <secret removed>')
    cfg.gsub!(/^([\s\t]*\S*)passphrase \S+/, '\1passphrase <secret removed>')
    cfg.gsub!(/community \S+/, 'community <secret removed>')
    cfg.gsub!(/community-name \S+/, 'community-name <secret removed>')
    cfg.gsub!(/^([\s\t]*\S*)encrypted \S+$/, '\1encrypted <secret removed>')
    cfg
  end

  cmd('tmsh -q show sys version') { |cfg| comment cfg }

  cmd('tmsh -q show sys hardware') { |cfg| comment cfg }

  cmd('tmsh -q show sys software status') { |cfg| comment cfg }

  cmd 'tmsh -q -c "cd /;list recursive"' do |cfg|
    cfg.gsub!(/state (up|down|checking|irule-down)/, '')
    cfg.gsub!(/errors (\d+)/, '')
    cfg.gsub!(/^\s+bandwidth-bps (\d+)/, '')
    cfg.gsub!(/^\s+bandwidth-cps (\d+)/, '')
    cfg.gsub!(/^\s+bandwidth-pps (\d+)\n/, '')
    cfg
  end

  cmd('tmsh -q list net route all') { |cfg| comment cfg }

  cmd 'tmsh -q show running-config sys db all-properties' do |cfg|
    cfg.gsub!(/sys db configsync.localconfigtime {[^}]+}/m, '')
    cfg.gsub!(/sys db gtm.configtime {[^}]+}/m, '')
    cfg.gsub!(/sys db ltm.configtime {[^}]+}/m, '')
    comment cfg
  end

  cmd('[ -d "/config/zebos" ] && tail -v -n+1 /config/zebos/*/ZebOS.conf') { |cfg| comment cfg }

  cmd('tail -v -n+1 /config/bigip.license') { |cfg| comment cfg }

  cmd('/bin/ls -d --full-time --color=never /config/ssl/ssl.crt/*') { |cfg| comment cfg }

  cmd('/bin/ls -d --full-time --color=never /config/ssl/ssl.key/*') { |cfg| comment cfg }

  cfg :ssh do
    exec true # don't run shell, run each command in exec channel
  end
end
