project('hotdoc-gnome-theme', 'c', version: '0.5')

theme = subproject('hotdoc_bootstrap_theme',
  default_options: ['less_include_path=' +
  join_paths(meson.current_source_dir(), 'less')]
)

dist = find_program('dist.py')

run_target('tar', command : [dist,
   theme.get_variable('theme_dir'),
   join_paths(meson.current_source_dir(),
     'hotdoc-gnome-theme-' + meson.project_version() + '.tar.xz')]
)
