desc "Run watchr (observr)"
task :watchr do
  # sh %{bundle exec watchr .watchr}
  system "bundle exec observr .watchr"
end

