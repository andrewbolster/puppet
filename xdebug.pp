class xdebuggable {
  file {
    'xdebug.ini':
    notify	=> Service["apache2"],
    path    => '/etc/php5/apache2/conf.d/xdebug.ini',
    ensure  => present,
    mode    => 0640,
    content => "[xdebug]
zend_extension=xdebug.so
xdebug.cli_color = 1
xdebug.scream = 1
xdebug.show_exception_trace = 1

[xdebug-remote-debug]
xdebug.remote_enable = On
xdebug.remote_autostart = 0
xdebug.remote_mode = req
xdebug.remote_connect_back = 1
xdebug.idekey = macgdbp
xdebug.file_link_format = \javascript: var r = new XMLHttpRequest; r.open(\\\"get\\\", \\\"http://localhost:8091?message=%f:%l\\\");r.send()\"
xdebug.collect_return = 1
xdebug.collect_vars = 1
xdebug.collect_params = 4

[xdebug-profiling]
xdebug.profiler_enable_trigger = 1
xdebug.profiler_enable = 0
xdebug.profiler_output_dir = /mnt/Sites/Dwelltime/profile
xdebug.profiler_output_name = cachegrind.out.%t.%R.%p
",
  }
}
include xdebuggable